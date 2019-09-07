
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/hwloc

REQUIRES           = libs/hwloc/1.11.3
REQUIRES          += X11/libs/cairo/1.14.6-x86_32
REQUIRES          += X11/X.org/lib/libpciaccess/0.13.4-x86_32
REQUIRES          += libs/libxml2/2.9.3-x86_32
REQUIRES          += app/pciutils/3.4.1-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.11.3
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/hwloc/hwloc-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/hwloc-$(version)
src_dir_name       = hwloc-$(version)
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
HWLOC_32_PKG_NAME                = hwloc-x32
HWLOC_32_PKG_VERSION             = 1.11.3
HWLOC_32_PKG_ARCH                = $(TOOLCHAIN)
HWLOC_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
HWLOC_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
HWLOC_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
HWLOC_32_PKG_SHORT_DESCRIPTION   = Portable Hardware Locality
HWLOC_32_PKG_URL                 = $(BUG_URL)
HWLOC_32_PKG_LICENSE             = BSD
HWLOC_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(HWLOC_32_PKG_NAME)-pkg-description
HWLOC_32_PKG_DESCRIPTION_FILE_IN = $(HWLOC_32_PKG_NAME)-pkg-description.in
HWLOC_32_PKG_INSTALL_SCRIPT      = $(HWLOC_32_PKG_NAME)-pkg-install.sh

HWLOC_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(HWLOC_32_PKG_NAME)-package

pkg_basename     = $(HWLOC_32_PKG_NAME)-$(HWLOC_32_PKG_VERSION)-$(HWLOC_32_PKG_ARCH)-$(HWLOC_32_PKG_DISTRO_NAME)-$(HWLOC_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(HWLOC_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

#
# Fix cpuid-x86 build error with gcc -O3 on x86-32.
# Thanks to Thomas Van Doren for reporting the issue.
#
OPTIMIZATION_FLAGS = -O2


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
	@mkdir -p $(HWLOC_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(HWLOC_32_PKG)/usr/include
	@rm -rf $(HWLOC_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(HWLOC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libhwloc.la  \
	 )
	@( cd $(HWLOC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" hwloc.pc  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(HWLOC_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libhwloc.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libhwloc.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" hwloc.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(HWLOC_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(HWLOC_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(HWLOC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(HWLOC_32_PKG_DESCRIPTION_FILE): $(HWLOC_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(HWLOC_32_PKG_DESCRIPTION_FILE) $(HWLOC_32_PKG_INSTALL_SCRIPT)
	@cp $(HWLOC_32_PKG_DESCRIPTION_FILE) $(HWLOC_32_PKG)/.DESCRIPTION
	@cp $(HWLOC_32_PKG_INSTALL_SCRIPT) $(HWLOC_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(HWLOC_32_PKG)/.REQUIRES
	@echo "pkgname=$(HWLOC_32_PKG_NAME)"                            >  $(HWLOC_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(HWLOC_32_PKG_VERSION)"                          >> $(HWLOC_32_PKG)/.PKGINFO ; \
	 echo "arch=$(HWLOC_32_PKG_ARCH)"                               >> $(HWLOC_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(HWLOC_32_PKG_DISTRO_NAME)"                  >> $(HWLOC_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(HWLOC_32_PKG_DISTRO_VERSION)"                >> $(HWLOC_32_PKG)/.PKGINFO ; \
	 echo "group=$(HWLOC_32_PKG_GROUP)"                             >> $(HWLOC_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(HWLOC_32_PKG_SHORT_DESCRIPTION)\"" >> $(HWLOC_32_PKG)/.PKGINFO ; \
	 echo "url=$(HWLOC_32_PKG_URL)"                                 >> $(HWLOC_32_PKG)/.PKGINFO ; \
	 echo "license=$(HWLOC_32_PKG_LICENSE)"                         >> $(HWLOC_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(HWLOC_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
