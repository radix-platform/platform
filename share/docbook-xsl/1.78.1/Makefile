
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/linuxdoc-tools/docbook-xsl
SOURCE_REQUIRES   += sources/packages/a/linuxdoc-tools/docbook-xsl-doc

REQUIRES           = libs/libxml2/2.9.1
REQUIRES          += libs/libxslt/1.1.28
REQUIRES          += share/docbook-xml/4.5

# ======= __END_OF_REQUIRES__ =======


version            = 1.78.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/linuxdoc-tools/docbook-xsl/docbook-xsl-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/docbook-xsl-$(version)
src_dir_name       = docbook-xsl-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

doc_version        = 1.78.1
doc_src_path       = $(SRC_PACKAGE_PATH)/packages/a/linuxdoc-tools/docbook-xsl-doc
doc_bz2_tarball    = $(addsuffix .tar.bz2, $(addprefix $(doc_src_path)/docbook-xsl-doc-, $(doc_version)))

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = doc

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
XSL_PKG_NAME                = docbook-xsl
XSL_PKG_VERSION             = 1.78.1
XSL_PKG_ARCH                = $(TOOLCHAIN)
XSL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
XSL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
XSL_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
XSL_PKG_SHORT_DESCRIPTION   = DocBook XSL Stylesheets
XSL_PKG_URL                 = $(BUG_URL)
XSL_PKG_LICENSE             = custom
XSL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(XSL_PKG_NAME)-pkg-description
XSL_PKG_DESCRIPTION_FILE_IN = $(XSL_PKG_NAME)-pkg-description.in
XSL_PKG_INSTALL_SCRIPT      = $(TARGET_BUILD_DIR)/$(XSL_PKG_NAME)-pkg-install.sh
XSL_PKG_INSTALL_SCRIPT_IN   = $(XSL_PKG_NAME)-pkg-install.sh.in

XSL_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(XSL_PKG_NAME)-package

pkg_basename     = $(XSL_PKG_NAME)-$(XSL_PKG_VERSION)-$(XSL_PKG_ARCH)-$(XSL_PKG_DISTRO_NAME)-$(XSL_PKG_DISTRO_VERSION)

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

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	@tar xjf $(doc_bz2_tarball) -C $(TARGET_BUILD_DIR)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(XSL_PKG)
	@( cd $(SRC_DIR) ; \
	   mkdir -pm755 $(XSL_PKG)/usr/share/xml/docbook/xsl-stylesheets-$(version)   ; \
	   cp -fa VERSION assembly common eclipse extensions epub epub3 fo highlighting \
	          html htmlhelp images javahelp lib manpages params profiling roundtrip \
	          slides template tools website xhtml xhtml-1_1 xhtml5                  \
	          $(XSL_PKG)/usr/share/xml/docbook/xsl-stylesheets-$(version) ; \
	   mkdir -pm755 $(XSL_PKG)/usr/share/xml/docbook/stylesheet ; \
	   ( cd $(XSL_PKG)/usr/share/xml/docbook/stylesheet ; \
	     rm -f docbook-xsl ; \
	     ln -sf ../xsl-stylesheets-$(version) docbook-xsl ) ; \
	   if [ ! -r $(XSL_PKG)/usr/share/xml/docbook/stylesheet/docbook-xsl/VERSION.xsl ] ; then \
	     ( cd $(XSL_PKG)/usr/share/xml/docbook/stylesheet/docbook-xsl ; \
	       ln -sf VERSION VERSION.xsl ) ; \
	   fi ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -pm755 $(XSL_PKG)/etc/xml
	# ======= Install Documentation =======
	@mkdir -p $(XSL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(XSL_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(XSL_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS BUGS COPYING INSTALL NEWS README RELEASE-NOTES.txt TODO \
	       $(XSL_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a doc/* $(XSL_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(XSL_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(XSL_PKG))
	@touch $@

$(XSL_PKG_DESCRIPTION_FILE): $(XSL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(XSL_PKG_INSTALL_SCRIPT): $(XSL_PKG_INSTALL_SCRIPT_IN)
	@cat $< | $(SED) -e "s,@VERSION@,$(version),g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(XSL_PKG_DESCRIPTION_FILE) $(XSL_PKG_INSTALL_SCRIPT)
	@cp $(XSL_PKG_DESCRIPTION_FILE) $(XSL_PKG)/.DESCRIPTION
	@cp $(XSL_PKG_INSTALL_SCRIPT) $(XSL_PKG)/.INSTALL
	@chmod a+x $(XSL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(XSL_PKG)/.REQUIRES
	@echo "pkgname=$(XSL_PKG_NAME)"                            >  $(XSL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(XSL_PKG_VERSION)"                          >> $(XSL_PKG)/.PKGINFO ; \
	 echo "arch=$(XSL_PKG_ARCH)"                               >> $(XSL_PKG)/.PKGINFO ; \
	 echo "distroname=$(XSL_PKG_DISTRO_NAME)"                  >> $(XSL_PKG)/.PKGINFO ; \
	 echo "distrover=$(XSL_PKG_DISTRO_VERSION)"                >> $(XSL_PKG)/.PKGINFO ; \
	 echo "group=$(XSL_PKG_GROUP)"                             >> $(XSL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(XSL_PKG_SHORT_DESCRIPTION)\"" >> $(XSL_PKG)/.PKGINFO ; \
	 echo "url=$(XSL_PKG_URL)"                                 >> $(XSL_PKG)/.PKGINFO ; \
	 echo "license=$(XSL_PKG_LICENSE)"                         >> $(XSL_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(XSL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
