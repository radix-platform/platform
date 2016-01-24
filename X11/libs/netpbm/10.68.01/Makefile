
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/netpbm
SOURCE_REQUIRES   += sources/packages/l/netpbm-doc

REQUIRES           = libs/zlib/1.2.8
REQUIRES          += app/xz/5.2.2
REQUIRES          += libs/libxml2/2.9.1
REQUIRES          += app/jbigkit/2.1
REQUIRES          += libs/libpng/libpng14/1.4.13
REQUIRES          += libs/libtiff/4.0.3
REQUIRES          += libs/libjpeg-turbo/1.3.1
REQUIRES          += X11/X.org/lib/libX11/1.6.2
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

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
NETPBM_PKG_NAME                = netpbm
NETPBM_PKG_VERSION             = 10.68.01
NETPBM_PKG_ARCH                = $(TOOLCHAIN)
NETPBM_PKG_DISTRO_NAME         = $(DISTRO_NAME)
NETPBM_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
NETPBM_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
NETPBM_PKG_SHORT_DESCRIPTION   = graphics conversion utilities
NETPBM_PKG_URL                 = $(BUG_URL)
NETPBM_PKG_LICENSE             = GPLv2
NETPBM_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NETPBM_PKG_NAME)-pkg-description
NETPBM_PKG_DESCRIPTION_FILE_IN = $(NETPBM_PKG_NAME)-pkg-description.in
NETPBM_PKG_INSTALL_SCRIPT      = $(NETPBM_PKG_NAME)-pkg-install.sh

NETPBM_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NETPBM_PKG_NAME)-package

pkg_basename     = $(NETPBM_PKG_NAME)-$(NETPBM_PKG_VERSION)-$(NETPBM_PKG_ARCH)-$(NETPBM_PKG_DISTRO_NAME)-$(NETPBM_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


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
	@mkdir -p $(NETPBM_PKG)/usr/share/man/man{1,3,5}
	@( cd $(SRC_DIR) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) $(configure_switches) \
	                                pkgdir=$(NETPBM_PKG)/usr \
	                                PKGMANDIR=share/man install-run install-dev ; \
	   rm $(NETPBM_PKG)/usr/share/man/man{1,3,5}/* ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) $(configure_switches) \
	                                MAKEMAN="$(CURDIR)/$(SRC_DIR)/buildtools/makeman" \
	                                MANDIR=$(NETPBM_PKG)/usr/share/man \
	                                -C ../userguide -f "$(CURDIR)/$(SRC_DIR)/buildtools/manpage.mk" installman ; \
	 )
	@( cd $(NETPBM_PKG)/usr ; \
	   if [ "$(LIBSUFFIX)" != "" ] ; then \
	     mv lib lib$(LIBSUFFIX) ; \
	   fi ; \
	 )
	@( cd $(NETPBM_PKG)/usr/lib$(LIBSUFFIX) ; \
	   rm -f libnetpbm.so ; \
	   ln -sf libnetpbm.so.?? libnetpbm.so ; \
	 )
	# ======= Remove obsolete utility =======
	@echo -e '#!/bin/sh\n\npamditherbw $$@ | pamtopnm' > $(NETPBM_PKG)/usr/bin/pgmtopbm
	# ======= Install Documentation =======
	@mkdir -p $(NETPBM_PKG)/usr/doc/$(src_dir_name)
	@( cd $(SRC_DIR)/doc ; \
	   cp -a COPYRIGHT.PATENT copyright_summary patent_summary *.txt \
	         $(NETPBM_PKG)/usr/doc/$(src_dir_name) ; \
	 )
	@mkdir -p $(NETPBM_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR)/doc ; \
	   cp -a ../README COPYRIGHT.PATENT INSTALL Netpbm.programming \
	         README.CYGWIN TESTS USERDOC copyright_summary patent_summary *.txt \
	         $(NETPBM_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR)/doc ; \
	   if [ -r HISTORY ]; then \
	     DOCSDIR=`echo $(NETPBM_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat HISTORY | head -n 1000 > $$DOCSDIR/HISTORY ; \
	     touch -r HISTORY $$DOCSDIR/HISTORY ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(NETPBM_PKG))
	# ======= Strip binaries =======
	@( cd $(NETPBM_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(NETPBM_PKG_DESCRIPTION_FILE): $(NETPBM_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(NETPBM_PKG_DESCRIPTION_FILE) $(NETPBM_PKG_INSTALL_SCRIPT)
	@cp $(NETPBM_PKG_DESCRIPTION_FILE) $(NETPBM_PKG)/.DESCRIPTION
	@cp $(NETPBM_PKG_INSTALL_SCRIPT) $(NETPBM_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NETPBM_PKG)/.REQUIRES
	@echo "pkgname=$(NETPBM_PKG_NAME)"                            >  $(NETPBM_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NETPBM_PKG_VERSION)"                          >> $(NETPBM_PKG)/.PKGINFO ; \
	 echo "arch=$(NETPBM_PKG_ARCH)"                               >> $(NETPBM_PKG)/.PKGINFO ; \
	 echo "distroname=$(NETPBM_PKG_DISTRO_NAME)"                  >> $(NETPBM_PKG)/.PKGINFO ; \
	 echo "distrover=$(NETPBM_PKG_DISTRO_VERSION)"                >> $(NETPBM_PKG)/.PKGINFO ; \
	 echo "group=$(NETPBM_PKG_GROUP)"                             >> $(NETPBM_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NETPBM_PKG_SHORT_DESCRIPTION)\"" >> $(NETPBM_PKG)/.PKGINFO ; \
	 echo "url=$(NETPBM_PKG_URL)"                                 >> $(NETPBM_PKG)/.PKGINFO ; \
	 echo "license=$(NETPBM_PKG_LICENSE)"                         >> $(NETPBM_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(NETPBM_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
