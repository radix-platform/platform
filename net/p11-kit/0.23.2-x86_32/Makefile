
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/n/p11-kit

REQUIRES             = net/p11-kit/0.23.2
REQUIRES            += libs/libffi/3.2.1-x86_32
REQUIRES            += libs/libtasn1/4.7-x86_32

# ======= __END_OF_REQUIRES__ =======


version              = 0.23.2
tar_gz_archive       = $(SRC_PACKAGE_PATH)/packages/n/p11-kit/p11-kit-$(version).tar.gz
SRC_ARCHIVE          = $(tar_gz_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/p11-kit-$(version)
src_dir_name         = p11-kit-$(version)
src_done             = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir            = $(TARGET_BUILD_DIR)/build
build_target         = $(TARGET_BUILD_DIR)/.build_done
install_target       = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
P11KIT_32_PKG_NAME                = p11-kit-x32
P11KIT_32_PKG_VERSION             = 0.23.2
P11KIT_32_PKG_ARCH                = $(TOOLCHAIN)
P11KIT_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
P11KIT_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
P11KIT_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
P11KIT_32_PKG_SHORT_DESCRIPTION   = PKCS 11 toolkit
P11KIT_32_PKG_URL                 = $(BUG_URL)
P11KIT_32_PKG_LICENSE             = GPLv2
P11KIT_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(P11KIT_32_PKG_NAME)-pkg-description
P11KIT_32_PKG_DESCRIPTION_FILE_IN = $(P11KIT_32_PKG_NAME)-pkg-description.in
P11KIT_32_PKG_INSTALL_SCRIPT      = $(P11KIT_32_PKG_NAME)-pkg-install.sh

P11KIT_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(P11KIT_32_PKG_NAME)-package

pkg_basename     = $(P11KIT_32_PKG_NAME)-$(P11KIT_32_PKG_VERSION)-$(P11KIT_32_PKG_ARCH)-$(P11KIT_32_PKG_DISTRO_NAME)-$(P11KIT_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(P11KIT_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --bindir=/usr/bin/32


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


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
	@mkdir -p $(P11KIT_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(P11KIT_32_PKG)/etc
	@rm -rf $(P11KIT_32_PKG)/usr/include
	@rm -rf $(P11KIT_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(P11KIT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libp11-kit.la ; \
	   sed -i "s,-L/usr/lib ,,g" libp11-kit.la ; \
	   sed -i "s,-L/lib ,,g" libp11-kit.la ; \
	 )
	@( cd $(P11KIT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkcs11 ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" p11-kit-trust.la ; \
	   sed -i "s,-L/usr/lib ,,g" p11-kit-trust.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(P11KIT_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libp11-kit.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libp11-kit.la  \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkcs11 ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" p11-kit-trust.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" p11-kit-trust.la  \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" p11-kit-1.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(P11KIT_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(P11KIT_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(P11KIT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(P11KIT_32_PKG_DESCRIPTION_FILE): $(P11KIT_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(P11KIT_32_PKG_DESCRIPTION_FILE) $(P11KIT_32_PKG_INSTALL_SCRIPT)
	@cp $(P11KIT_32_PKG_DESCRIPTION_FILE) $(P11KIT_32_PKG)/.DESCRIPTION
	@cp $(P11KIT_32_PKG_INSTALL_SCRIPT) $(P11KIT_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(P11KIT_32_PKG)/.REQUIRES
	@echo "pkgname=$(P11KIT_32_PKG_NAME)"                            >  $(P11KIT_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(P11KIT_32_PKG_VERSION)"                          >> $(P11KIT_32_PKG)/.PKGINFO ; \
	 echo "arch=$(P11KIT_32_PKG_ARCH)"                               >> $(P11KIT_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(P11KIT_32_PKG_DISTRO_NAME)"                  >> $(P11KIT_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(P11KIT_32_PKG_DISTRO_VERSION)"                >> $(P11KIT_32_PKG)/.PKGINFO ; \
	 echo "group=$(P11KIT_32_PKG_GROUP)"                             >> $(P11KIT_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(P11KIT_32_PKG_SHORT_DESCRIPTION)\"" >> $(P11KIT_32_PKG)/.PKGINFO ; \
	 echo "url=$(P11KIT_32_PKG_URL)"                                 >> $(P11KIT_32_PKG)/.PKGINFO ; \
	 echo "license=$(P11KIT_32_PKG_LICENSE)"                         >> $(P11KIT_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(P11KIT_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
