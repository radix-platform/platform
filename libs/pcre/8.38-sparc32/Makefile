
COMPONENT_TARGETS  = $(HARDWARE_MBC4_PC)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_SPARC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/pcre

REQUIRES           = libs/pcre/8.38
REQUIRES          += app/bzip2/1.0.6-sparc32
REQUIRES          += libs/readline/8.0-sparc32

# ======= __END_OF_REQUIRES__ =======


version            = 8.38
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/pcre/pcre-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/pcre-$(version)
src_dir_name       = pcre-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PCRE_32_PKG_NAME                = pcre-x32
PCRE_32_PKG_VERSION             = 8.38
PCRE_32_PKG_ARCH                = $(TOOLCHAIN)
PCRE_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PCRE_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PCRE_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
PCRE_32_PKG_SHORT_DESCRIPTION   = Perl-compatible regular expression library
PCRE_32_PKG_URL                 = $(BUG_URL)
PCRE_32_PKG_LICENSE             = GPLv2
PCRE_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PCRE_32_PKG_NAME)-pkg-description
PCRE_32_PKG_DESCRIPTION_FILE_IN = $(PCRE_32_PKG_NAME)-pkg-description.in
PCRE_32_PKG_INSTALL_SCRIPT      = $(PCRE_32_PKG_NAME)-pkg-install.sh

PCRE_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PCRE_32_PKG_NAME)-package

pkg_basename     = $(PCRE_32_PKG_NAME)-$(PCRE_32_PKG_VERSION)-$(PCRE_32_PKG_ARCH)-$(PCRE_32_PKG_DISTRO_NAME)-$(PCRE_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(PCRE_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_SPARC32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-utf8
extra_configure_switches += --enable-pcre16
extra_configure_switches += --enable-pcre32
extra_configure_switches += --enable-unicode-properties

extra_configure_switches += --enable-pcregrep-libz
extra_configure_switches += --enable-pcregrep-libbz2
extra_configure_switches += --enable-pcretest-libreadline

ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


TARGET_LIB_RPATH = /lib$(MULTILIB_SPARC32_SUFFIX):/usr/lib$(MULTILIB_SPARC32_SUFFIX):/usr/lib/../lib$(MULTILIB_SPARC32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PCRE_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(PCRE_32_PKG)/usr/bin ; \
	   mkdir 32 ; \
	   mv pcre* 32 \
	 )
	@rm -rf $(PCRE_32_PKG)/usr/include
	@rm -rf $(PCRE_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PCRE_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpcre.la libpcre16.la libpcre32.la libpcrecpp.la libpcreposix.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PCRE_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpcre.la libpcre16.la libpcre32.la libpcrecpp.la libpcreposix.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpcre.la libpcre16.la libpcre32.la libpcrecpp.la libpcreposix.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpcre.pc libpcre16.pc libpcre32.pc libpcrecpp.pc libpcreposix.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(PCRE_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(PCRE_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(PCRE_32_PKG_DESCRIPTION_FILE): $(PCRE_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PCRE_32_PKG_DESCRIPTION_FILE) $(PCRE_32_PKG_INSTALL_SCRIPT)
	@cp $(PCRE_32_PKG_DESCRIPTION_FILE) $(PCRE_32_PKG)/.DESCRIPTION
	@cp $(PCRE_32_PKG_INSTALL_SCRIPT) $(PCRE_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PCRE_32_PKG)/.REQUIRES
	@echo "pkgname=$(PCRE_32_PKG_NAME)"                            >  $(PCRE_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PCRE_32_PKG_VERSION)"                          >> $(PCRE_32_PKG)/.PKGINFO ; \
	 echo "arch=$(PCRE_32_PKG_ARCH)"                               >> $(PCRE_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PCRE_32_PKG_DISTRO_NAME)"                  >> $(PCRE_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PCRE_32_PKG_DISTRO_VERSION)"                >> $(PCRE_32_PKG)/.PKGINFO ; \
	 echo "group=$(PCRE_32_PKG_GROUP)"                             >> $(PCRE_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PCRE_32_PKG_SHORT_DESCRIPTION)\"" >> $(PCRE_32_PKG)/.PKGINFO ; \
	 echo "url=$(PCRE_32_PKG_URL)"                                 >> $(PCRE_32_PKG)/.PKGINFO ; \
	 echo "license=$(PCRE_32_PKG_LICENSE)"                         >> $(PCRE_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PCRE_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
