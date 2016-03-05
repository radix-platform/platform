
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


include ../../../../build-system/constants.mk


SOURCE_REQUIRES     = sources/dict/aspell/ca

REQUIRES            = base/pkgtool

# ======= __END_OF_REQUIRES__ =======


version             = 2.1.5-1
tar_bz2_archive     = $(SRC_PACKAGE_PATH)/dict/aspell/ca/aspell6-ca-2.1.5-1.tar.bz2
SRC_ARCHIVE         = $(tar_bz2_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/aspell6-ca-2.1.5-1
doc_dir_name        = words-ca-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dict

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
WORDS_PKG_NAME                = words-ca
WORDS_PKG_VERSION             = 2.1.5-1
WORDS_PKG_ARCH                = $(TOOLCHAIN)
WORDS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
WORDS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
WORDS_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
WORDS_PKG_SHORT_DESCRIPTION   = Catalan wordlist
WORDS_PKG_URL                 = $(BUG_URL)
WORDS_PKG_LICENSE             = GPLv2
WORDS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(WORDS_PKG_NAME)-pkg-description
WORDS_PKG_DESCRIPTION_FILE_IN = $(WORDS_PKG_NAME)-pkg-description.in
WORDS_PKG_INSTALL_SCRIPT      = $(TARGET_BUILD_DIR)/$(WORDS_PKG_NAME)-pkg-install.sh
WORDS_PKG_INSTALL_SCRIPT_IN   = $(WORDS_PKG_NAME)-pkg-install.sh.in

WORDS_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(WORDS_PKG_NAME)-package

pkg_basename     = $(WORDS_PKG_NAME)-$(WORDS_PKG_VERSION)-$(WORDS_PKG_ARCH)-$(WORDS_PKG_DISTRO_NAME)-$(WORDS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


language  = Catalan
spelling  = catalan
wordlist  = catala
country   = Catalonia

man_page_template = $(CURDIR)/man/wordlist.5.in


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   set -e ; \
	   mkdir -p built ; \
	   cat $(man_page_template) | sed -e "s/@WORDLIST@/$(spelling)/g" | \
	                              sed -e "s/@LANGUAGE@/$(language)/g" > built/$(spelling).5 ; \
	   preunzip *.cwl ; \
	   for wl in *.wl ; do \
	     iconv --from-code=ISO-8859-1 --to-code=UTF-8 $$wl | \
	     cut -d '/' -f 1 > $$wl.utf8 ; \
	   done ; \
	   rm *.wl ; \
	   cat ca-*.wl.utf8 | sort -u > built/$(wordlist) ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(WORDS_PKG)/usr/share/dict
	# ======= install wordlists =======
	@( cd $(SRC_DIR)/built ; \
	   cp $(wordlist) $(WORDS_PKG)/usr/share/dict ; \
	   chmod 0644 $(WORDS_PKG)/usr/share/dict/* \
	 )
	# ======= man pages =======
	@mkdir -p $(WORDS_PKG)/usr/share/man/man5
	@( cd $(SRC_DIR)/built ; \
	   cat $(spelling).5 | gzip -9c > $(WORDS_PKG)/usr/share/man/man5/$(spelling).5.gz ; \
	 )
	# ======= Aspell Dictionaries Documentation =======
	@mkdir -p $(WORDS_PKG)/usr/doc/words/$(doc_dir_name)
	@cp -a $(SRC_DIR)/COPYING $(SRC_DIR)/Copyright $(WORDS_PKG)/usr/doc/words/$(doc_dir_name)
	@mkdir -p $(WORDS_PKG)/usr/share/doc/words/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING Copyright README \
	         $(WORDS_PKG)/usr/share/doc/words/$(doc_dir_name) ; \
	 )
	@( cd $(SRC_DIR)/doc ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(WORDS_PKG)/usr/share/doc/words/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(WORDS_PKG))
	@touch $@

$(WORDS_PKG_DESCRIPTION_FILE): $(WORDS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g"   | \
	          $(SED) -e "s/@LANGUAGE@/$(language)/g" | \
	          $(SED) -e "s/@COUNTRY@/$(country)/g"   | \
	          $(SED) -e "s/@WORDLIST@/$(wordlist)/g"   > $@

$(WORDS_PKG_INSTALL_SCRIPT): $(WORDS_PKG_INSTALL_SCRIPT_IN)
	@cat $< | $(SED) -e "s/@WORDLIST@/$(wordlist)/g" | \
	          $(SED) -e "s/@SPELLING@/$(spelling)/g"   > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(WORDS_PKG_DESCRIPTION_FILE) $(WORDS_PKG_INSTALL_SCRIPT)
	@cp $(WORDS_PKG_DESCRIPTION_FILE) $(WORDS_PKG)/.DESCRIPTION
	@cp $(WORDS_PKG_INSTALL_SCRIPT) $(WORDS_PKG)/.INSTALL
	@chmod a+x $(WORDS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(WORDS_PKG)/.REQUIRES
	@echo "pkgname=$(WORDS_PKG_NAME)"                            >  $(WORDS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(WORDS_PKG_VERSION)"                          >> $(WORDS_PKG)/.PKGINFO ; \
	 echo "arch=$(WORDS_PKG_ARCH)"                               >> $(WORDS_PKG)/.PKGINFO ; \
	 echo "distroname=$(WORDS_PKG_DISTRO_NAME)"                  >> $(WORDS_PKG)/.PKGINFO ; \
	 echo "distrover=$(WORDS_PKG_DISTRO_VERSION)"                >> $(WORDS_PKG)/.PKGINFO ; \
	 echo "group=$(WORDS_PKG_GROUP)"                             >> $(WORDS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(WORDS_PKG_SHORT_DESCRIPTION)\"" >> $(WORDS_PKG)/.PKGINFO ; \
	 echo "url=$(WORDS_PKG_URL)"                                 >> $(WORDS_PKG)/.PKGINFO ; \
	 echo "license=$(WORDS_PKG_LICENSE)"                         >> $(WORDS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(WORDS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
