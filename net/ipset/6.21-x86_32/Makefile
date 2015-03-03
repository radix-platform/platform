
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/n/ipset

REQUIRES             = net/ipset/6.21
REQUIRES            += net/libmnl/1.0.3-x86_32


version              = 6.21
tar_bz2_archive      = $(SRC_PACKAGE_PATH)/packages/n/ipset/ipset-$(version).tar.bz2
SRC_ARCHIVE          = $(tar_bz2_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/ipset-$(version)
src_dir_name         = ipset-$(version)
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
IPSET_32_PKG_NAME                = ipset-x32
IPSET_32_PKG_VERSION             = 6.21
IPSET_32_PKG_ARCH                = $(TOOLCHAIN)
IPSET_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
IPSET_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
IPSET_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
IPSET_32_PKG_SHORT_DESCRIPTION   = administration tool for kernel IP sets
IPSET_32_PKG_URL                 = $(BUG_URL)
IPSET_32_PKG_LICENSE             = GPLv2
IPSET_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(IPSET_32_PKG_NAME)-pkg-description
IPSET_32_PKG_DESCRIPTION_FILE_IN = $(IPSET_32_PKG_NAME)-pkg-description.in
IPSET_32_PKG_INSTALL_SCRIPT      = $(IPSET_32_PKG_NAME)-pkg-install.sh

IPSET_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(IPSET_32_PKG_NAME)-package

pkg_basename     = $(IPSET_32_PKG_NAME)-$(IPSET_32_PKG_VERSION)-$(IPSET_32_PKG_ARCH)-$(IPSET_32_PKG_DISTRO_NAME)-$(IPSET_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(IPSET_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@mkdir -p $(IPSET_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(IPSET_32_PKG)/usr/sbin/32
	@( cd $(IPSET_32_PKG)/usr/sbin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(IPSET_32_PKG)/usr/include
	@rm -rf $(IPSET_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(IPSET_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libipset.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(IPSET_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libipset.la  ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libipset.la  \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libipset.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(IPSET_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(IPSET_32_PKG)/usr/sbin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(IPSET_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(IPSET_32_PKG_DESCRIPTION_FILE): $(IPSET_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(IPSET_32_PKG_DESCRIPTION_FILE) $(IPSET_32_PKG_INSTALL_SCRIPT)
	@cp $(IPSET_32_PKG_DESCRIPTION_FILE) $(IPSET_32_PKG)/.DESCRIPTION
	@cp $(IPSET_32_PKG_INSTALL_SCRIPT) $(IPSET_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(IPSET_32_PKG)/.REQUIRES
	@echo "pkgname=$(IPSET_32_PKG_NAME)"                            >  $(IPSET_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(IPSET_32_PKG_VERSION)"                          >> $(IPSET_32_PKG)/.PKGINFO ; \
	 echo "arch=$(IPSET_32_PKG_ARCH)"                               >> $(IPSET_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(IPSET_32_PKG_DISTRO_NAME)"                  >> $(IPSET_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(IPSET_32_PKG_DISTRO_VERSION)"                >> $(IPSET_32_PKG)/.PKGINFO ; \
	 echo "group=$(IPSET_32_PKG_GROUP)"                             >> $(IPSET_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(IPSET_32_PKG_SHORT_DESCRIPTION)\"" >> $(IPSET_32_PKG)/.PKGINFO ; \
	 echo "url=$(IPSET_32_PKG_URL)"                                 >> $(IPSET_32_PKG)/.PKGINFO ; \
	 echo "license=$(IPSET_32_PKG_LICENSE)"                         >> $(IPSET_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(IPSET_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
