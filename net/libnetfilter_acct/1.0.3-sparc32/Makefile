
COMPONENT_TARGETS  = $(HARDWARE_MBC4_PC)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_SPARC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES   = sources/packages/n/libnetfilter_acct

REQUIRES          = net/libnetfilter_acct/1.0.3
REQUIRES         += net/libmnl/1.0.4-sparc32

# ======= __END_OF_REQUIRES__ =======


version           = 1.0.3
tar_bz2_archive   = $(SRC_PACKAGE_PATH)/packages/n/libnetfilter_acct/libnetfilter_acct-$(version).tar.bz2
SRC_ARCHIVE       = $(tar_bz2_archive)
SRC_DIR           = $(TARGET_BUILD_DIR)/libnetfilter_acct-$(version)
src_dir_name      = libnetfilter_acct-$(version)
src_done          = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir         = $(TARGET_BUILD_DIR)/build
build_target      = $(TARGET_BUILD_DIR)/.build_done
install_target    = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBNF_ACCT_32_PKG_NAME                = libnetfilter_acct-x32
LIBNF_ACCT_32_PKG_VERSION             = 1.0.3
LIBNF_ACCT_32_PKG_ARCH                = $(TOOLCHAIN)
LIBNF_ACCT_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBNF_ACCT_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBNF_ACCT_32_PKG_GROUP               = $(PKG_GROUP)
###                                    |---handy-ruler-------------------------------|
LIBNF_ACCT_32_PKG_SHORT_DESCRIPTION   = library for netfilter accounting
LIBNF_ACCT_32_PKG_URL                 = $(BUG_URL)
LIBNF_ACCT_32_PKG_LICENSE             = LGPLv2.1
LIBNF_ACCT_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBNF_ACCT_32_PKG_NAME)-pkg-description
LIBNF_ACCT_32_PKG_DESCRIPTION_FILE_IN = $(LIBNF_ACCT_32_PKG_NAME)-pkg-description.in
LIBNF_ACCT_32_PKG_INSTALL_SCRIPT      = $(LIBNF_ACCT_32_PKG_NAME)-pkg-install.sh

LIBNF_ACCT_32_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBNF_ACCT_32_PKG_NAME)-package

pkg_basename      = $(LIBNF_ACCT_32_PKG_NAME)-$(LIBNF_ACCT_32_PKG_VERSION)-$(LIBNF_ACCT_32_PKG_ARCH)-$(LIBNF_ACCT_32_PKG_DISTRO_NAME)-$(LIBNF_ACCT_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate   = $(call cert-name,$(pkg_archive))
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBNF_ACCT_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_SPARC32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


LDFLAGS += -Wl,-rpath,/lib$(MULTILIB_SPARC32_SUFFIX):/usr/lib$(MULTILIB_SPARC32_SUFFIX):/usr/lib/../lib$(MULTILIB_SPARC32_SUFFIX)

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
	@mkdir -p $(LIBNF_ACCT_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBNF_ACCT_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBNF_ACCT_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libnetfilter_acct.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBNF_ACCT_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   libnetfilter_acct.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libnetfilter_acct.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libnetfilter_acct.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBNF_ACCT_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(LIBNF_ACCT_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBNF_ACCT_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBNF_ACCT_32_PKG_DESCRIPTION_FILE): $(LIBNF_ACCT_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBNF_ACCT_32_PKG_DESCRIPTION_FILE) $(LIBNF_ACCT_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBNF_ACCT_32_PKG_DESCRIPTION_FILE) $(LIBNF_ACCT_32_PKG)/.DESCRIPTION
	@cp $(LIBNF_ACCT_32_PKG_INSTALL_SCRIPT) $(LIBNF_ACCT_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBNF_ACCT_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBNF_ACCT_32_PKG_NAME)"                            >  $(LIBNF_ACCT_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBNF_ACCT_32_PKG_VERSION)"                          >> $(LIBNF_ACCT_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBNF_ACCT_32_PKG_ARCH)"                               >> $(LIBNF_ACCT_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBNF_ACCT_32_PKG_DISTRO_NAME)"                  >> $(LIBNF_ACCT_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBNF_ACCT_32_PKG_DISTRO_VERSION)"                >> $(LIBNF_ACCT_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBNF_ACCT_32_PKG_GROUP)"                             >> $(LIBNF_ACCT_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBNF_ACCT_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBNF_ACCT_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBNF_ACCT_32_PKG_URL)"                                 >> $(LIBNF_ACCT_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBNF_ACCT_32_PKG_LICENSE)"                         >> $(LIBNF_ACCT_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBNF_ACCT_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
