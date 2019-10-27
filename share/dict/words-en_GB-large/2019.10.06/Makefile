
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP2E)
COMPONENT_TARGETS += $(HARDWARE_NANOPI_NEO)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PL2)
COMPONENT_TARGETS += $(HARDWARE_WECHIP_TX6)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_RK3328_CC)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_EDGE)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OKMX6DL_C)
COMPONENT_TARGETS += $(HARDWARE_OKMX6Q_C)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BAIKAL_T1)
COMPONENT_TARGETS += $(HARDWARE_MBC4_PC)
COMPONENT_TARGETS += $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_S824L_LSB)
COMPONENT_TARGETS += $(HARDWARE_VESNIN_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2_LSB)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES     = sources/dict/scowl

REQUIRES            = base/radix-system

# ======= __END_OF_REQUIRES__ =======


version             = 2019.10.06
tar_gz_archive      = $(SRC_PACKAGE_PATH)/dict/scowl/scowl-$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/scowl-$(version)
doc_dir_name        = words-en_GB-large-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

readme_file_in      = $(CURDIR)/doc/README.in

PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dict

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
WORDS_PKG_NAME                = words-en_GB-large
WORDS_PKG_VERSION             = 2019.10.06
WORDS_PKG_ARCH                = $(TOOLCHAIN)
WORDS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
WORDS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
WORDS_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
WORDS_PKG_SHORT_DESCRIPTION   = British English large wordlist
WORDS_PKG_URL                 = $(BUG_URL)
WORDS_PKG_LICENSE             = public
WORDS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(WORDS_PKG_NAME)-pkg-description
WORDS_PKG_DESCRIPTION_FILE_IN = $(WORDS_PKG_NAME)-pkg-description.in
WORDS_PKG_INSTALL_SCRIPT      = $(TARGET_BUILD_DIR)/$(WORDS_PKG_NAME)-pkg-install.sh
WORDS_PKG_INSTALL_SCRIPT_IN   = $(WORDS_PKG_NAME)-pkg-install.sh.in

WORDS_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(WORDS_PKG_NAME)-package

pkg_basename     = $(WORDS_PKG_NAME)-$(WORDS_PKG_VERSION)-$(WORDS_PKG_ARCH)-$(WORDS_PKG_DISTRO_NAME)-$(WORDS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk

#
# Values of  'wordlist', 'country'  variables should be set by hand
# according to configuration variables 'sizes', 'spellings' defined
# below.
#
wordlist = british-english-large
country  = British

man_page_template = $(CURDIR)/man/wordlist.5.in

#
# available package sizes: small "" large huge insane
#
sizes = large

# scowl file extensions:
size_exts_small  :=                    10 20 35
size_exts        := $(size_exts_small) 40 50
size_exts_large  := $(size_exts)       55 60 70
size_exts_huge   := $(size_exts_large) 80
size_exts_insane := $(size_exts_huge)  95

export size_exts_small
export size_exts
export size_exts_large
export size_exts_huge
export size_exts_insane

#
# available scowl languages: american british canadian
#
spellings := british

# scowl word list classes:
classes   := words proper-names upper contractions
variants  := 0 1


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   set -e ; \
	   for spelling in $(spellings) ; do \
	     suffix= ; \
	     if   [ "$$spelling" == "american" ] ; then suffix="en_US" ; \
	     elif [ "$$spelling" == "british"  ] ; then suffix="en_GB" ; \
	     elif [ "$$spelling" == "canadian" ] ; then suffix="en_CA" ; \
	     else suffix= ; \
	     fi ; \
	     for size in $(sizes) ; do \
	       if [ -n "$$size" ] ; then sizename="_$$size" ; size="-$$size" ; else sizename="" ; size="" ; fi ; \
	       echo ""                                                      > words-$$suffix$$size.scowl-wordlists ; \
	       echo "The following SCOWL word lists were concatenated and" >> words-$$suffix$$size.scowl-wordlists ; \
	       echo "sorted (with duplicates removed) to create this word" >> words-$$suffix$$size.scowl-wordlists ; \
	       echo "list:"                                                >> words-$$suffix$$size.scowl-wordlists ; \
	       echo ""                                                     >> words-$$suffix$$size.scowl-wordlists ; \
	       for class in $(classes) ; do \
	         for ext in $$(eval echo "\$$""size_exts$$sizename") ; do \
	           if [ "$$sizename" != "" ] ; then \
	             echo "####### collecting: class=$$class ext=$$ext size=`echo $$sizename | sed -e 's/^_//'` ..." ; \
	           else \
	             echo "####### collecting: class=$$class ext=$$ext ..." ; \
	           fi ; \
	           if [ -f final/english-$$class.$$ext ] ; then \
	             cat final/english-$$class.$$ext >> $$spelling-english$$size.unsorted ; \
	             echo "   english-$$class.$$ext" >> words-$$suffix$$size.scowl-wordlists ; \
	           fi ; \
	           for variant in $(variants) ; do \
	             if [ -f final/variant_$$variant-$$class.$$ext ] ; then \
	               cat final/variant_$$variant-$$class.$$ext >> $$spelling-english$$size.unsorted ; \
	               echo "   variant_$$variant-$$class.$$ext" >> words-$$suffix$$size.scowl-wordlists ; \
	             fi ; \
	           done ; \
	           if [ "$$size" = "insane" ] ; then \
	             for special in special_hacker.50 ; do \
	               cat final/final/$$special >> $$spelling-english$$size.unsorted ; \
	               echo "   final/$$special" >> words-$$suffix$$size.scowl-wordlists ; \
	             done ; \
	           fi ; \
	           if [ -f final/$$spelling-$$class.$$ext ] ; then \
	             cat final/$$spelling-$$class.$$ext >> $$spelling-english$$size.unsorted ; \
	             echo "   $$spelling-$$class.$$ext" >> words-$$suffix$$size.scowl-wordlists ; \
	           fi ; \
	         done ; \
	       done ; \
	       echo "####### dictionary: $$spelling-english$$size - done" ; \
	       cat $$spelling-english$$size.unsorted | sort -u | iconv -f 'iso8859-1' -t 'utf-8' > $$spelling-english$$size ; rm $$spelling-english$$size.unsorted ; \
	       cat $(man_page_template) | sed -e "s/@WORDLIST@/$$spelling-english$$size/g" > $$spelling-english$$size.5 ; \
	     done ; \
	   done \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(WORDS_PKG)/usr/share/dict
	# ======= install wordlists =======
	@( cd $(SRC_DIR) ; \
	   cp $(wordlist) $(WORDS_PKG)/usr/share/dict ; \
	   chmod 0644 $(WORDS_PKG)/usr/share/dict/* \
	 )
	# ======= man pages =======
	@mkdir -p $(WORDS_PKG)/usr/share/man/man5
	@( cd $(SRC_DIR) ; \
	   cat $(wordlist).5 | gzip -9c > $(WORDS_PKG)/usr/share/man/man5/$(wordlist).5.gz ; \
	 )
	# ======= SCOWL documentation =======
	@mkdir -p $(WORDS_PKG)/usr/doc/words/$(doc_dir_name)
	@cp -a $(SRC_DIR)/Copyright $(WORDS_PKG)/usr/doc/words/$(doc_dir_name)
	@mkdir -p $(WORDS_PKG)/usr/share/doc/words/$(doc_dir_name)/scowl
	@( cd $(SRC_DIR) ; \
	   cp -a Copyright README VERSION \
	         $(WORDS_PKG)/usr/share/doc/words/$(doc_dir_name)/scowl ; \
	 )
	# ======= documentation =======
	@( cd $(SRC_DIR) ; \
	   cp -a $(WORDS_PKG_NAME).scowl-wordlists \
	         $(WORDS_PKG)/usr/share/doc/words/$(doc_dir_name) ; \
	 )
	@cat $(readme_file_in) | \
	   $(SED) -e "s/@VERSION@/$(version)/g"        | \
	   $(SED) -e "s/@PACKAGE@/$(WORDS_PKG_NAME)/g" > \
	   $(WORDS_PKG)/usr/share/doc/words/$(doc_dir_name)/README
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(WORDS_PKG))
	@touch $@

$(WORDS_PKG_DESCRIPTION_FILE): $(WORDS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g"   | \
	          $(SED) -e "s/@WORDLIST@/$(wordlist)/g" | \
	          $(SED) -e "s/@COUNTRY@/$(country)/g"     > $@

$(WORDS_PKG_INSTALL_SCRIPT): $(WORDS_PKG_INSTALL_SCRIPT_IN)
	@cat $< | $(SED) -e "s/@WORDLIST@/$(wordlist)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
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
	@$(PSEUDO) sh -c "cd $(WORDS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
