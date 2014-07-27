
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/aspell

REQUIRES           = libs/aspell/0.60.6.1
REQUIRES          += libs/eglibc/2.19.1
REQUIRES          += libs/ncurses/5.9-x86_32


version            = 0.60.6.1
base_version       = $(shell echo $(version) | sed -e 's/\([0-9].[0-9]*\)\([\.].*\)/\1/')
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/aspell/aspell-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/aspell-$(version)
src_dir_name       = aspell-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ASPELL_32_PKG_NAME                = aspell-x32
ASPELL_32_PKG_VERSION             = 0.60.6.1
ASPELL_32_PKG_ARCH                = $(TOOLCHAIN)
ASPELL_32_PKG_DISTRO_NAME         = kxLab
ASPELL_32_PKG_DISTRO_VERSION      = 1.0
ASPELL_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
ASPELL_32_PKG_SHORT_DESCRIPTION   = aspell-x32 $(version)
ASPELL_32_PKG_URL                 = $(BUG_URL)
ASPELL_32_PKG_LICENSE             = LGPLv2
ASPELL_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ASPELL_32_PKG_NAME)-pkg-description
ASPELL_32_PKG_DESCRIPTION_FILE_IN = $(ASPELL_32_PKG_NAME)-pkg-description.in
ASPELL_32_PKG_INSTALL_SCRIPT      = $(ASPELL_32_PKG_NAME)-pkg-install.sh

ASPELL_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ASPELL_32_PKG_NAME)-package

pkg_basename     = $(ASPELL_32_PKG_NAME)-$(ASPELL_32_PKG_VERSION)-$(ASPELL_32_PKG_ARCH)-$(ASPELL_32_PKG_DISTRO_NAME)-$(ASPELL_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(ASPELL_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-rpath


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ASPELL_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@( cd $(ASPELL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; ln -sf aspell-$(base_version) aspell )
	@mkdir -p $(ASPELL_32_PKG)/usr/bin/32
	@( cd $(ASPELL_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(ASPELL_32_PKG)/usr/include
	@rm -rf $(ASPELL_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(ASPELL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libaspell.la libpspell.la \
	 )
	@( cd $(ASPELL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/aspell-$(base_version) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" context-filter.la email-filter.la \
	                                    nroff-filter.la sgml-filter.la    \
	                                    tex-filter.la texinfo-filter.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(ASPELL_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libaspell.la libpspell.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libaspell.la libpspell.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/aspell-$(base_version) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" context-filter.la email-filter.la \
	                                            nroff-filter.la sgml-filter.la    \
	                                            tex-filter.la texinfo-filter.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" context-filter.la email-filter.la \
	                                              nroff-filter.la sgml-filter.la    \
	                                              tex-filter.la texinfo-filter.la ; \
	 )
	# ======= Strip binaries =======
	@( cd $(ASPELL_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(ASPELL_32_PKG_DESCRIPTION_FILE): $(ASPELL_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ASPELL_32_PKG_DESCRIPTION_FILE) $(ASPELL_32_PKG_INSTALL_SCRIPT)
	@cp $(ASPELL_32_PKG_DESCRIPTION_FILE) $(ASPELL_32_PKG)/.DESCRIPTION
	@cp $(ASPELL_32_PKG_INSTALL_SCRIPT) $(ASPELL_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ASPELL_32_PKG)/.REQUIRES
	@echo "pkgname=$(ASPELL_32_PKG_NAME)"                            >  $(ASPELL_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ASPELL_32_PKG_VERSION)"                          >> $(ASPELL_32_PKG)/.PKGINFO ; \
	 echo "arch=$(ASPELL_32_PKG_ARCH)"                               >> $(ASPELL_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(ASPELL_32_PKG_DISTRO_NAME)"                  >> $(ASPELL_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(ASPELL_32_PKG_DISTRO_VERSION)"                >> $(ASPELL_32_PKG)/.PKGINFO ; \
	 echo "group=$(ASPELL_32_PKG_GROUP)"                             >> $(ASPELL_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ASPELL_32_PKG_SHORT_DESCRIPTION)\"" >> $(ASPELL_32_PKG)/.PKGINFO ; \
	 echo "url=$(ASPELL_32_PKG_URL)"                                 >> $(ASPELL_32_PKG)/.PKGINFO ; \
	 echo "license=$(ASPELL_32_PKG_LICENSE)"                         >> $(ASPELL_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ASPELL_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
