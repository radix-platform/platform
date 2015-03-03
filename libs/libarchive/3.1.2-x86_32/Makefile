
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libarchive

REQUIRES           = libs/libarchive/3.1.2
REQUIRES          += libs/eglibc/2.19.1-x86_32
REQUIRES          += app/acl/2.2.52-x86_32
REQUIRES          += app/attr/2.4.47-x86_32
REQUIRES          += app/bzip2/1.0.6-x86_32
REQUIRES          += libs/expat/2.1.0-x86_32
REQUIRES          += libs/lzo/2.08-x86_32
REQUIRES          += net/openssl/1.0.1g-x86_32
REQUIRES          += net/nettle/2.7.1-x86_32
REQUIRES          += app/xz/5.0.5-x86_32
REQUIRES          += libs/zlib/1.2.8-x86_32
REQUIRES          += libs/libxml2/2.9.1-x86_32


version            = 3.1.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libarchive/libarchive-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libarchive-$(version)
src_dir_name       = libarchive-$(version)
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
LIBARCHIVE_32_PKG_NAME                = libarchive-x32
LIBARCHIVE_32_PKG_VERSION             = 3.1.2
LIBARCHIVE_32_PKG_ARCH                = $(TOOLCHAIN)
LIBARCHIVE_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBARCHIVE_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBARCHIVE_32_PKG_GROUP               = $(PKG_GROUP)
###                                    |---handy-ruler-------------------------------|
LIBARCHIVE_32_PKG_SHORT_DESCRIPTION   = archive reading library
LIBARCHIVE_32_PKG_URL                 = $(BUG_URL)
LIBARCHIVE_32_PKG_LICENSE             = custom
LIBARCHIVE_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBARCHIVE_32_PKG_NAME)-pkg-description
LIBARCHIVE_32_PKG_DESCRIPTION_FILE_IN = $(LIBARCHIVE_32_PKG_NAME)-pkg-description.in
LIBARCHIVE_32_PKG_INSTALL_SCRIPT      = $(LIBARCHIVE_32_PKG_NAME)-pkg-install.sh

LIBARCHIVE_32_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBARCHIVE_32_PKG_NAME)-package

pkg_basename      = $(LIBARCHIVE_32_PKG_NAME)-$(LIBARCHIVE_32_PKG_VERSION)-$(LIBARCHIVE_32_PKG_ARCH)-$(LIBARCHIVE_32_PKG_DISTRO_NAME)-$(LIBARCHIVE_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBARCHIVE_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	@mkdir -p $(LIBARCHIVE_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(LIBARCHIVE_32_PKG)/usr/bin/32
	@( cd $(LIBARCHIVE_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(LIBARCHIVE_32_PKG)/usr/include
	@rm -rf $(LIBARCHIVE_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBARCHIVE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libarchive.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBARCHIVE_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libarchive.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libarchive.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libarchive.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBARCHIVE_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(LIBARCHIVE_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBARCHIVE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBARCHIVE_32_PKG_DESCRIPTION_FILE): $(LIBARCHIVE_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBARCHIVE_32_PKG_DESCRIPTION_FILE) $(LIBARCHIVE_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBARCHIVE_32_PKG_DESCRIPTION_FILE) $(LIBARCHIVE_32_PKG)/.DESCRIPTION
	@cp $(LIBARCHIVE_32_PKG_INSTALL_SCRIPT) $(LIBARCHIVE_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBARCHIVE_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBARCHIVE_32_PKG_NAME)"                            >  $(LIBARCHIVE_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBARCHIVE_32_PKG_VERSION)"                          >> $(LIBARCHIVE_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBARCHIVE_32_PKG_ARCH)"                               >> $(LIBARCHIVE_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBARCHIVE_32_PKG_DISTRO_NAME)"                  >> $(LIBARCHIVE_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBARCHIVE_32_PKG_DISTRO_VERSION)"                >> $(LIBARCHIVE_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBARCHIVE_32_PKG_GROUP)"                             >> $(LIBARCHIVE_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBARCHIVE_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBARCHIVE_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBARCHIVE_32_PKG_URL)"                                 >> $(LIBARCHIVE_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBARCHIVE_32_PKG_LICENSE)"                         >> $(LIBARCHIVE_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBARCHIVE_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
