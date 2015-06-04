
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


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/linuxdoc-tools/docbook-xml/4.x

REQUIRES           = libs/libxml2/2.9.1
REQUIRES          += share/sgml-common/0.6.3

# ======= __END_OF_REQUIRES__ =======


version            = 4.5
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/linuxdoc-tools/docbook-xml/4.x/docbook-xml-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/docbook-xml-$(version)
src_dir_name       = docbook-xml-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

old_versions       = 4.4 4.3 4.2 4.1.2
old_src_path       = $(SRC_PACKAGE_PATH)/packages/a/linuxdoc-tools/docbook-xml/4.x
old_bz2_tarballs   = $(addsuffix .tar.bz2, $(addprefix $(old_src_path)/docbook-xml-, $(old_versions)))

license            = $(CURDIR)/license/COPYING

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = doc

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DTD_PKG_NAME                = docbook-xml
DTD_PKG_VERSION             = 4.5
DTD_PKG_ARCH                = $(TOOLCHAIN)
DTD_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DTD_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DTD_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
DTD_PKG_SHORT_DESCRIPTION   = Document Type Definitions
DTD_PKG_URL                 = $(BUG_URL)
DTD_PKG_LICENSE             = MIT
DTD_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DTD_PKG_NAME)-pkg-description
DTD_PKG_DESCRIPTION_FILE_IN = $(DTD_PKG_NAME)-pkg-description.in
DTD_PKG_INSTALL_SCRIPT      = $(DTD_PKG_NAME)-pkg-install.sh

DTD_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DTD_PKG_NAME)-package

pkg_basename     = $(DTD_PKG_NAME)-$(DTD_PKG_VERSION)-$(DTD_PKG_ARCH)-$(DTD_PKG_DISTRO_NAME)-$(DTD_PKG_DISTRO_VERSION)

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
	@for tarball in $(old_bz2_tarballs) ; do \
	  tar xjf $$tarball -C $(TARGET_BUILD_DIR) ; \
	 done
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(DTD_PKG)
	# ====== Create DTDs catalogs for old versions ======
	@for dtdver in $(old_versions) ; do \
	  mkdir -pm755 $(DTD_PKG)/usr/share/xml/docbook/xml-dtd-$$dtdver ; \
	  ( cd $(TARGET_BUILD_DIR)/docbook-xml-$$dtdver ; \
	    chmod 0644 *.dtd *.mod ; \
	    cp -fa docbook.cat *.dtd *.mod ent \
	           $(DTD_PKG)/usr/share/xml/docbook/xml-dtd-$$dtdver ) ; \
	 done
	# ====== Create DTD V$(version) catalog ======
	@mkdir -pm755 $(DTD_PKG)/usr/share/xml/docbook/xml-dtd-$(version)
	@( cd $(SRC_DIR) ; \
	   chmod 0644 *.dtd *.mod ; \
	   cp -fa docbook.cat *.dtd *.mod ent \
	          $(DTD_PKG)/usr/share/xml/docbook/xml-dtd-$(version) )
	@touch $@

$(install_target): $(build_target)
	@mkdir -pm755 $(DTD_PKG)/etc/xml
	@xmlcatalog --noout --create $(DTD_PKG)/etc/xml/docbook-xml
	@for xmldtdver in `for r in $(version) $(old_versions) ; do echo "$$r" ; done | sort -V | uniq` ; do \
	   xmlcatalog --noout --add "public" \
	     "-//OASIS//DTD DocBook XML V$${xmldtdver}//EN" \
	     "http://www.oasis-open.org/docbook/xml/$${xmldtdver}/docbookx.dtd" \
	     $(DTD_PKG)/etc/xml/docbook-xml && \
	   xmlcatalog --noout --add "public" \
	     "-//OASIS//DTD DocBook XML CALS Table Model V$${xmldtdver}//EN" \
	     "file:///usr/share/xml/docbook/xml-dtd-$${xmldtdver}/calstblx.dtd" \
	     $(DTD_PKG)/etc/xml/docbook-xml && \
	   xmlcatalog --noout --add "public" \
	     "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
	     "file:///usr/share/xml/docbook/xml-dtd-$${xmldtdver}/soextblx.dtd" \
	     $(DTD_PKG)/etc/xml/docbook-xml && \
	   xmlcatalog --noout --add "public" \
	     "-//OASIS//ELEMENTS DocBook XML Information Pool V$${xmldtdver}//EN" \
	     "file:///usr/share/xml/docbook/xml-dtd-$${xmldtdver}/dbpoolx.mod" \
	     $(DTD_PKG)/etc/xml/docbook-xml && \
	   xmlcatalog --noout --add "public" \
	     "-//OASIS//ELEMENTS DocBook XML Document Hierarchy V$${xmldtdver}//EN" \
	     "file:///usr/share/xml/docbook/xml-dtd-$${xmldtdver}/dbhierx.mod" \
	     $(DTD_PKG)/etc/xml/docbook-xml && \
	   xmlcatalog --noout --add "public" \
	     "-//OASIS//ELEMENTS DocBook XML HTML Tables V$${xmldtdver}//EN" \
	     "file:///usr/share/xml/docbook/xml-dtd-$${xmldtdver}/htmltblx.mod" \
	     $(DTD_PKG)/etc/xml/docbook-xml && \
	   xmlcatalog --noout --add "public" \
	     "-//OASIS//ENTITIES DocBook XML Notations V$${xmldtdver}//EN" \
	     "file:///usr/share/xml/docbook/xml-dtd-$${xmldtdver}/dbnotnx.mod" \
	     $(DTD_PKG)/etc/xml/docbook-xml && \
	   xmlcatalog --noout --add "public" \
	     "-//OASIS//ENTITIES DocBook XML Character Entities V$${xmldtdver}//EN" \
	     "file:///usr/share/xml/docbook/xml-dtd-$${xmldtdver}/dbcentx.mod" \
	     $(DTD_PKG)/etc/xml/docbook-xml && \
	   xmlcatalog --noout --add "public" \
	     "-//OASIS//ENTITIES DocBook XML Additional General Entities V$${xmldtdver}//EN" \
	     "file:///usr/share/xml/docbook/xml-dtd-$${xmldtdver}/dbgenent.mod" \
	     $(DTD_PKG)/etc/xml/docbook-xml && \
	   xmlcatalog --noout --add "rewriteSystem" \
	     "http://www.oasis-open.org/docbook/xml/$${xmldtdver}" \
	     "file:///usr/share/xml/docbook/xml-dtd-$${xmldtdver}" \
	     $(DTD_PKG)/etc/xml/docbook-xml && \
	   xmlcatalog --noout --add "rewriteURI" \
	     "http://www.oasis-open.org/docbook/xml/$${xmldtdver}" \
	     "file:///usr/share/xml/docbook/xml-dtd-$${xmldtdver}" \
	     $(DTD_PKG)/etc/xml/docbook-xml ; \
	 done
	# ======= Install Documentation =======
	@mkdir -p $(DTD_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(license) \
	       $(DTD_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(DTD_PKG)/usr/share/doc/$(src_dir_name)
	@cp -a $(license) $(SRC_DIR)/README \
	       $(DTD_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(DTD_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(DTD_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@touch $@

$(DTD_PKG_DESCRIPTION_FILE): $(DTD_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DTD_PKG_DESCRIPTION_FILE) $(DTD_PKG_INSTALL_SCRIPT)
	@cp $(DTD_PKG_DESCRIPTION_FILE) $(DTD_PKG)/.DESCRIPTION
	@cp $(DTD_PKG_INSTALL_SCRIPT) $(DTD_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DTD_PKG)/.REQUIRES
	@echo "pkgname=$(DTD_PKG_NAME)"                            >  $(DTD_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DTD_PKG_VERSION)"                          >> $(DTD_PKG)/.PKGINFO ; \
	 echo "arch=$(DTD_PKG_ARCH)"                               >> $(DTD_PKG)/.PKGINFO ; \
	 echo "distroname=$(DTD_PKG_DISTRO_NAME)"                  >> $(DTD_PKG)/.PKGINFO ; \
	 echo "distrover=$(DTD_PKG_DISTRO_VERSION)"                >> $(DTD_PKG)/.PKGINFO ; \
	 echo "group=$(DTD_PKG_GROUP)"                             >> $(DTD_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DTD_PKG_SHORT_DESCRIPTION)\"" >> $(DTD_PKG)/.PKGINFO ; \
	 echo "url=$(DTD_PKG_URL)"                                 >> $(DTD_PKG)/.PKGINFO ; \
	 echo "license=$(DTD_PKG_LICENSE)"                         >> $(DTD_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(DTD_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
