
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/n/libgcrypt

REQUIRES             = net/libgcrypt/1.6.2
REQUIRES            += net/libassuan/2.1.2-x86_32
REQUIRES            += net/libksba/1.3.1-x86_32
REQUIRES            += libs/pth/2.0.7-x86_32

# ======= __END_OF_REQUIRES__ =======


version              = 1.6.2
tar_bz2_archive      = $(SRC_PACKAGE_PATH)/packages/n/libgcrypt/libgcrypt-$(version).tar.bz2
SRC_ARCHIVE          = $(tar_bz2_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/libgcrypt-$(version)
src_dir_name         = libgcrypt-$(version)
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
GCRYPT_32_PKG_NAME                = libgcrypt-x32
GCRYPT_32_PKG_VERSION             = 1.6.2
GCRYPT_32_PKG_ARCH                = $(TOOLCHAIN)
GCRYPT_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GCRYPT_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GCRYPT_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
GCRYPT_32_PKG_SHORT_DESCRIPTION   = General purpose crypto library
GCRYPT_32_PKG_URL                 = $(BUG_URL)
GCRYPT_32_PKG_LICENSE             = GPLv2
GCRYPT_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GCRYPT_32_PKG_NAME)-pkg-description
GCRYPT_32_PKG_DESCRIPTION_FILE_IN = $(GCRYPT_32_PKG_NAME)-pkg-description.in
GCRYPT_32_PKG_INSTALL_SCRIPT      = $(GCRYPT_32_PKG_NAME)-pkg-install.sh

GCRYPT_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GCRYPT_32_PKG_NAME)-package

pkg_basename     = $(GCRYPT_32_PKG_NAME)-$(GCRYPT_32_PKG_VERSION)-$(GCRYPT_32_PKG_ARCH)-$(GCRYPT_32_PKG_DISTRO_NAME)-$(GCRYPT_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(GCRYPT_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --program-prefix=""
extra_configure_switches += --program-suffix=""
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC) $(TOOLCHAIN_I686_GLIBC)),)
extra_configure_switches += --disable-asm
endif

libs_config  = GPG_ERROR_CONFIG=$(TARGET_DEST_DIR)/usr/bin/32/gpg-error-config
libs_config += PTH_CONFIG=$(TARGET_DEST_DIR)/usr/bin/32/pth-config


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(libs_config) LIBS=-lpth ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GCRYPT_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(GCRYPT_32_PKG)/usr/bin/32
	@( cd $(GCRYPT_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@mkdir -p $(GCRYPT_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(GCRYPT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   chmod +w lib*.so.*.*.? ; \
	   mv lib*.so.*.*.? ../../lib$(MULTILIB_X86_32_SUFFIX) ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/lib*.so.*.*.? . ; \
	   cp -a lib*.so.?? ../../lib$(MULTILIB_X86_32_SUFFIX) ; \
	 )
	@rm -rf $(GCRYPT_32_PKG)/usr/include
	@rm -rf $(GCRYPT_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GCRYPT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgcrypt.la ; \
	 )
	@( cd $(GCRYPT_32_PKG)/usr/bin/32 ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgcrypt-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GCRYPT_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgcrypt.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgcrypt.la  \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i "s,prefix=\"/usr,prefix=\"$(TARGET_DEST_DIR)/usr,g" libgcrypt-config ; \
	   sed -i "s,libdir=\"/usr,libdir=\"$(TARGET_DEST_DIR)/usr,g" libgcrypt-config ; \
	   sed -i "s,-L/usr,-L$(TARGET_DEST_DIR)/usr,g" libgcrypt-config ; \
	   sed -i "s,-I/usr,-I$(TARGET_DEST_DIR)/usr,g" libgcrypt-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GCRYPT_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(GCRYPT_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GCRYPT_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GCRYPT_32_PKG_DESCRIPTION_FILE): $(GCRYPT_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GCRYPT_32_PKG_DESCRIPTION_FILE) $(GCRYPT_32_PKG_INSTALL_SCRIPT)
	@cp $(GCRYPT_32_PKG_DESCRIPTION_FILE) $(GCRYPT_32_PKG)/.DESCRIPTION
	@cp $(GCRYPT_32_PKG_INSTALL_SCRIPT) $(GCRYPT_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GCRYPT_32_PKG)/.REQUIRES
	@echo "pkgname=$(GCRYPT_32_PKG_NAME)"                            >  $(GCRYPT_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GCRYPT_32_PKG_VERSION)"                          >> $(GCRYPT_32_PKG)/.PKGINFO ; \
	 echo "arch=$(GCRYPT_32_PKG_ARCH)"                               >> $(GCRYPT_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GCRYPT_32_PKG_DISTRO_NAME)"                  >> $(GCRYPT_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GCRYPT_32_PKG_DISTRO_VERSION)"                >> $(GCRYPT_32_PKG)/.PKGINFO ; \
	 echo "group=$(GCRYPT_32_PKG_GROUP)"                             >> $(GCRYPT_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GCRYPT_32_PKG_SHORT_DESCRIPTION)\"" >> $(GCRYPT_32_PKG)/.PKGINFO ; \
	 echo "url=$(GCRYPT_32_PKG_URL)"                                 >> $(GCRYPT_32_PKG)/.PKGINFO ; \
	 echo "license=$(GCRYPT_32_PKG_LICENSE)"                         >> $(GCRYPT_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GCRYPT_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
