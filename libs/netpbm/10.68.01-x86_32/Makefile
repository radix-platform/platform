
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/netpbm
SOURCE_REQUIRES   += sources/packages/l/netpbm-doc

REQUIRES           = libs/netpbm/10.68.01
REQUIRES          += libs/zlib/1.2.8-x86_32
REQUIRES          += app/xz/5.2.2-x86_32
REQUIRES          += libs/libxml2/2.9.3-x86_32
REQUIRES          += app/jbigkit/2.1-x86_32
REQUIRES          += libs/libpng/libpng14/1.4.19-x86_32
REQUIRES          += libs/libtiff/4.0.6-x86_32
REQUIRES          += libs/libjpeg-turbo/1.4.2-x86_32
#
# Runtime required packages:
#
REQUIRES          += dev/perl/5.22.1

# ======= __END_OF_REQUIRES__ =======


version            = 10.68.01
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/netpbm/netpbm-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/netpbm-$(version)
src_dir_name       = netpbm-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

doc_version         = 20141125
tar_bz2_doc_archive = $(SRC_PACKAGE_PATH)/packages/l/netpbm-doc/netpbm-doc-$(doc_version).tar.bz2

config_in          = $(CURDIR)/config/config.mk.in

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
NETPBM_32_PKG_NAME                = netpbm-x32
NETPBM_32_PKG_VERSION             = 10.68.01
NETPBM_32_PKG_ARCH                = $(TOOLCHAIN)
NETPBM_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
NETPBM_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
NETPBM_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
NETPBM_32_PKG_SHORT_DESCRIPTION   = graphics conversion utilities
NETPBM_32_PKG_URL                 = $(BUG_URL)
NETPBM_32_PKG_LICENSE             = GPLv2
NETPBM_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NETPBM_32_PKG_NAME)-pkg-description
NETPBM_32_PKG_DESCRIPTION_FILE_IN = $(NETPBM_32_PKG_NAME)-pkg-description.in
NETPBM_32_PKG_INSTALL_SCRIPT      = $(NETPBM_32_PKG_NAME)-pkg-install.sh

NETPBM_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NETPBM_32_PKG_NAME)-package

pkg_basename     = $(NETPBM_32_PKG_NAME)-$(NETPBM_32_PKG_VERSION)-$(NETPBM_32_PKG_ARCH)-$(NETPBM_32_PKG_DISTRO_NAME)-$(NETPBM_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


configure_switches  = CC_FOR_BUILD=/usr/bin/gcc
configure_switches += LD_FOR_BUILD=/usr/bin/gcc
configure_switches += CFLAGS_FOR_BUILD=-I/usr/include
configure_switches += LDFLAGS_FOR_BUILD=-L/usr/lib$(BUILD_MULTILIB_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@echo "Expanding $(tar_bz2_doc_archive)"
	@tar xjf $(tar_bz2_doc_archive) -C $(TARGET_BUILD_DIR)
	@cd $(TARGET_BUILD_DIR); ln -sf netpbm-doc-$(doc_version) userguide
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   cp $(config_in) config.mk ; \
	   echo "NETPBM_DOCURL = file://$(CURDIR)/$(TARGET_BUILD_DIR)/userguide" >> config.mk ; \
	   sed -i 's|misc|share/netpbm|' common.mk ; \
	   sed -i 's|/link|/lib|' lib/Makefile ; \
	   sed -i 's|install.manwebmain install.manweb install.man|install.man|' GNUmakefile ; \
	 )
	@( cd $(SRC_DIR) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) $(configure_switches) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) $(configure_switches) \
	                                MAKEMAN="$(CURDIR)/$(SRC_DIR)/buildtools/makeman" USERGUIDE=../userguide \
	                                -C ../userguide -f "$(CURDIR)/$(SRC_DIR)/buildtools/manpage.mk" manpages ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(NETPBM_32_PKG)
	@( cd $(SRC_DIR) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) $(configure_switches) \
	                                pkgdir=$(NETPBM_32_PKG)/usr \
	                                PKGMANDIR=share/man install-run install-dev ; \
	   rm $(NETPBM_32_PKG)/usr/share/man/man{1,3,5}/* ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) $(configure_switches) \
	                                MAKEMAN="$(CURDIR)/$(SRC_DIR)/buildtools/makeman" \
	                                MANDIR=$(NETPBM_32_PKG)/usr/share/man \
	                                -C ../userguide -f "$(CURDIR)/$(SRC_DIR)/buildtools/manpage.mk" installman ; \
	 )
	@( cd $(NETPBM_32_PKG)/usr ; \
	   if [ "$(MULTILIB_X86_32_SUFFIX)" != "" ] ; then \
	     mv lib lib$(MULTILIB_X86_32_SUFFIX) ; \
	   fi ; \
	 )
	@( cd $(NETPBM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   rm -f libnetpbm.so ; \
	   ln -sf libnetpbm.so.?? libnetpbm.so ; \
	 )
	@mkdir -p $(NETPBM_32_PKG)/usr/bin/32
	@( cd $(NETPBM_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	   find . -type l | xargs mv -t 32 ; \
	 )
	# ======= Remove obsolete utility =======
	@echo -e '#!/bin/sh\n\npamditherbw $$@ | pamtopnm' > $(NETPBM_32_PKG)/usr/bin/32/pgmtopbm
	# ======= Remove unneeded directories =======
	@rm -rf $(NETPBM_32_PKG)/usr/include
	@rm -rf $(NETPBM_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(NETPBM_32_PKG))
	# ======= Strip binaries =======
	@( cd $(NETPBM_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(NETPBM_32_PKG_DESCRIPTION_FILE): $(NETPBM_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(NETPBM_32_PKG_DESCRIPTION_FILE) $(NETPBM_32_PKG_INSTALL_SCRIPT)
	@cp $(NETPBM_32_PKG_DESCRIPTION_FILE) $(NETPBM_32_PKG)/.DESCRIPTION
	@cp $(NETPBM_32_PKG_INSTALL_SCRIPT) $(NETPBM_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NETPBM_32_PKG)/.REQUIRES
	@echo "pkgname=$(NETPBM_32_PKG_NAME)"                            >  $(NETPBM_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NETPBM_32_PKG_VERSION)"                          >> $(NETPBM_32_PKG)/.PKGINFO ; \
	 echo "arch=$(NETPBM_32_PKG_ARCH)"                               >> $(NETPBM_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(NETPBM_32_PKG_DISTRO_NAME)"                  >> $(NETPBM_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(NETPBM_32_PKG_DISTRO_VERSION)"                >> $(NETPBM_32_PKG)/.PKGINFO ; \
	 echo "group=$(NETPBM_32_PKG_GROUP)"                             >> $(NETPBM_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NETPBM_32_PKG_SHORT_DESCRIPTION)\"" >> $(NETPBM_32_PKG)/.PKGINFO ; \
	 echo "url=$(NETPBM_32_PKG_URL)"                                 >> $(NETPBM_32_PKG)/.PKGINFO ; \
	 echo "license=$(NETPBM_32_PKG_LICENSE)"                         >> $(NETPBM_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(NETPBM_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
