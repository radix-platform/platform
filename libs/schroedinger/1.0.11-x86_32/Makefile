
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/schroedinger

REQUIRES           = libs/schroedinger/1.0.11
REQUIRES          += dev/orc/0.4.26.1-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.11
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/schroedinger/schroedinger-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/schroedinger-$(version)
src_dir_name       = schroedinger-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DIRAC_32_PKG_NAME                = schroedinger-x32
DIRAC_32_PKG_VERSION             = 1.0.11
DIRAC_32_PKG_ARCH                = $(TOOLCHAIN)
DIRAC_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DIRAC_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DIRAC_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
DIRAC_32_PKG_SHORT_DESCRIPTION   = Dirac video codec
DIRAC_32_PKG_URL                 = $(BUG_URL)
DIRAC_32_PKG_LICENSE             = MIT
DIRAC_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DIRAC_32_PKG_NAME)-pkg-description
DIRAC_32_PKG_DESCRIPTION_FILE_IN = $(DIRAC_32_PKG_NAME)-pkg-description.in
DIRAC_32_PKG_INSTALL_SCRIPT      = $(DIRAC_32_PKG_NAME)-pkg-install.sh

DIRAC_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DIRAC_32_PKG_NAME)-package

pkg_basename     = $(DIRAC_32_PKG_NAME)-$(DIRAC_32_PKG_VERSION)-$(DIRAC_32_PKG_ARCH)-$(DIRAC_32_PKG_DISTRO_NAME)-$(DIRAC_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(DIRAC_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-gtk-doc=no

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


CFLAGS += -Wno-strict-overflow


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DIRAC_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(DIRAC_32_PKG)/usr/include
	@rm -rf $(DIRAC_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(DIRAC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libschroedinger-?.?.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DIRAC_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libschroedinger-?.?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libschroedinger-?.?.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" schroedinger-?.?.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(DIRAC_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(DIRAC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(DIRAC_32_PKG_DESCRIPTION_FILE): $(DIRAC_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DIRAC_32_PKG_DESCRIPTION_FILE) $(DIRAC_32_PKG_INSTALL_SCRIPT)
	@cp $(DIRAC_32_PKG_DESCRIPTION_FILE) $(DIRAC_32_PKG)/.DESCRIPTION
	@cp $(DIRAC_32_PKG_INSTALL_SCRIPT) $(DIRAC_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DIRAC_32_PKG)/.REQUIRES
	@echo "pkgname=$(DIRAC_32_PKG_NAME)"                            >  $(DIRAC_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DIRAC_32_PKG_VERSION)"                          >> $(DIRAC_32_PKG)/.PKGINFO ; \
	 echo "arch=$(DIRAC_32_PKG_ARCH)"                               >> $(DIRAC_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(DIRAC_32_PKG_DISTRO_NAME)"                  >> $(DIRAC_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(DIRAC_32_PKG_DISTRO_VERSION)"                >> $(DIRAC_32_PKG)/.PKGINFO ; \
	 echo "group=$(DIRAC_32_PKG_GROUP)"                             >> $(DIRAC_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DIRAC_32_PKG_SHORT_DESCRIPTION)\"" >> $(DIRAC_32_PKG)/.PKGINFO ; \
	 echo "url=$(DIRAC_32_PKG_URL)"                                 >> $(DIRAC_32_PKG)/.PKGINFO ; \
	 echo "license=$(DIRAC_32_PKG_LICENSE)"                         >> $(DIRAC_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DIRAC_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
