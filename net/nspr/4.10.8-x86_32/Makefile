
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/n/mozilla-nspr

REQUIRES             = net/nspr/4.10.8

# ======= __END_OF_REQUIRES__ =======


version              = 4.10.8
tar_xz_archive       = $(SRC_PACKAGE_PATH)/packages/n/mozilla-nspr/nspr-$(version).tar.xz
SRC_ARCHIVE          = $(tar_xz_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/nspr-$(version)
src_dir_name         = nspr-$(version)
src_done             = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir            = $(TARGET_BUILD_DIR)/build
build_target         = $(TARGET_BUILD_DIR)/.build_done
install_target       = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
NSPR_32_PKG_NAME                = nspr-x32
NSPR_32_PKG_VERSION             = 4.10.8
NSPR_32_PKG_ARCH                = $(TOOLCHAIN)
NSPR_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
NSPR_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
NSPR_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
NSPR_32_PKG_SHORT_DESCRIPTION   = Netscape Portable Runtime
NSPR_32_PKG_URL                 = $(BUG_URL)
NSPR_32_PKG_LICENSE             = MPLv2
NSPR_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NSPR_32_PKG_NAME)-pkg-description
NSPR_32_PKG_DESCRIPTION_FILE_IN = $(NSPR_32_PKG_NAME)-pkg-description.in
NSPR_32_PKG_INSTALL_SCRIPT      = $(NSPR_32_PKG_NAME)-pkg-install.sh

NSPR_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NSPR_32_PKG_NAME)-package

pkg_basename     = $(NSPR_32_PKG_NAME)-$(NSPR_32_PKG_VERSION)-$(NSPR_32_PKG_ARCH)-$(NSPR_32_PKG_DISTRO_NAME)-$(NSPR_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(NSPR_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-strip=no

extra_configure_switches += --enable-ipv6
extra_configure_switches += --with-mozilla
extra_configure_switches += --with-pthreads

nspr_environment  = HOST_CC=gcc
nspr_environment += HOST_CFLAGS="-I. -I/usr/include -g -O2"
nspr_environment += HOST_LDFLAGS=


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(nspr_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(nspr_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(NSPR_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(NSPR_32_PKG)/usr/bin/32
	@( cd $(NSPR_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(NSPR_32_PKG)/usr/include
	@rm -rf $(NSPR_32_PKG)/usr/share
	# ======= remove executable attribute of static libraries =======
	@( cd $(NSPR_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   chmod a-x *.a ; \
	 )
	@( cd $(NSPR_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   ln -sf nspr.pc mozilla-nspr.pc ; \
	 )
	# ======= tune nspr-config for target system =======
	@( cd $(NSPR_32_PKG)/usr/bin/32 ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" nspr-config ; \
	   rm -f compile-et.pl prerr.properties ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(NSPR_32_PKG))
	# ======= tune nspr-config to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"     nspr-config ; \
	   sed -i "s,-L/lib,-L$(TARGET_DEST_DIR)/lib,g" nspr-config ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" nspr.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(NSPR_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(NSPR_32_PKG_DESCRIPTION_FILE): $(NSPR_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(NSPR_32_PKG_DESCRIPTION_FILE) $(NSPR_32_PKG_INSTALL_SCRIPT)
	@cp $(NSPR_32_PKG_DESCRIPTION_FILE) $(NSPR_32_PKG)/.DESCRIPTION
	@cp $(NSPR_32_PKG_INSTALL_SCRIPT) $(NSPR_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NSPR_32_PKG)/.REQUIRES
	@echo "pkgname=$(NSPR_32_PKG_NAME)"                            >  $(NSPR_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NSPR_32_PKG_VERSION)"                          >> $(NSPR_32_PKG)/.PKGINFO ; \
	 echo "arch=$(NSPR_32_PKG_ARCH)"                               >> $(NSPR_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(NSPR_32_PKG_DISTRO_NAME)"                  >> $(NSPR_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(NSPR_32_PKG_DISTRO_VERSION)"                >> $(NSPR_32_PKG)/.PKGINFO ; \
	 echo "group=$(NSPR_32_PKG_GROUP)"                             >> $(NSPR_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NSPR_32_PKG_SHORT_DESCRIPTION)\"" >> $(NSPR_32_PKG)/.PKGINFO ; \
	 echo "url=$(NSPR_32_PKG_URL)"                                 >> $(NSPR_32_PKG)/.PKGINFO ; \
	 echo "license=$(NSPR_32_PKG_LICENSE)"                         >> $(NSPR_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(NSPR_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
