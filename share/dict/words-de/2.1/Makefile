
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES     = sources/dict/aspell/de
SOURCE_REQUIRES    += sources/dict/aspell/de-alt

REQUIRES            = base/pkgtool


version             = 2.1
tar_bz2_archive     = $(SRC_PACKAGE_PATH)/dict/aspell/de/aspell6-de-20030222-1.tar.bz2
SRC_ARCHIVE         = $(tar_bz2_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/aspell6-de-20030222-1
doc_dir_name        = words-de-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

tar_bz2_alt_archive = $(SRC_PACKAGE_PATH)/dict/aspell/de-alt/aspell6-de-alt-2.1-1.tar.bz2
alt_src_dir         = $(TARGET_BUILD_DIR)/aspell6-de-alt-2.1-1


PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dict

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
WORDS_PKG_NAME                = words-de
WORDS_PKG_VERSION             = 2.1
WORDS_PKG_ARCH                = $(TOOLCHAIN)
WORDS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
WORDS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
WORDS_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
WORDS_PKG_SHORT_DESCRIPTION   = Deutch wordlist
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


language   = Deutch
spelling   = german
wordlist   = ngerman
countries  = German Switzerland Austria

man_page_template = $(CURDIR)/man/wordlist.5.in


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@tar xjf $(tar_bz2_alt_archive) -C $(TARGET_BUILD_DIR)
	@cp -a $(alt_src_dir)/README $(SRC_DIR)/README.alt
	@cp -a $(alt_src_dir)/de-alt.cwl $(SRC_DIR)/de-alt.cwl
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
	   cat de-common.wl.utf8 de_*.wl.utf8 | sort -u > built/ngerman ; \
	   cat                 de-alt.wl.utf8 | sort -u > built/ogerman ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(WORDS_PKG)/usr/share/dict
	# ======= install wordlists =======
	@( cd $(SRC_DIR)/built ; \
	   cp $(wordlist) ogerman $(WORDS_PKG)/usr/share/dict ; \
	   chmod 0644 $(WORDS_PKG)/usr/share/dict/* \
	 )
	# ======= man pages =======
	@mkdir -p $(WORDS_PKG)/usr/share/man/man5
	@( cd $(SRC_DIR)/built ; \
	   cat $(spelling).5 | gzip -9c > $(WORDS_PKG)/usr/share/man/man5/$(spelling).5.gz ; \
	 )
	# ======= Aspell Dictionaries Documentation =======
	@mkdir -p $(WORDS_PKG)/usr/doc/words/$(doc_dir_name)
	@cp -a $(SRC_DIR)/COPYING $(WORDS_PKG)/usr/doc/words/$(doc_dir_name)
	@mkdir -p $(WORDS_PKG)/usr/share/doc/words/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README* \
	         $(WORDS_PKG)/usr/share/doc/words/$(doc_dir_name) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(WORDS_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@touch $@

$(WORDS_PKG_DESCRIPTION_FILE): $(WORDS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g"   | \
	          $(SED) -e "s/@LANGUAGE@/$(language)/g" | \
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
