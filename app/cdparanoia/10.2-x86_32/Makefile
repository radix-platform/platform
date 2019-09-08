
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/xiph/cdparanoia

REQUIRES           = app/cdparanoia/10.2

# ======= __END_OF_REQUIRES__ =======


version            = 10.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/xiph/cdparanoia/cdparanoia-III-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/cdparanoia-III-$(version)
src_dir_name       = cdparanoia-III-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PARANOIA_32_PKG_NAME                = cdparanoia-x32
PARANOIA_32_PKG_VERSION             = 10.2
PARANOIA_32_PKG_ARCH                = $(TOOLCHAIN)
PARANOIA_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PARANOIA_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PARANOIA_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
PARANOIA_32_PKG_SHORT_DESCRIPTION   = digital audio extraction tool
PARANOIA_32_PKG_URL                 = $(BUG_URL)
PARANOIA_32_PKG_LICENSE             = GPLv2
PARANOIA_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PARANOIA_32_PKG_NAME)-pkg-description
PARANOIA_32_PKG_DESCRIPTION_FILE_IN = $(PARANOIA_32_PKG_NAME)-pkg-description.in
PARANOIA_32_PKG_INSTALL_SCRIPT      = $(PARANOIA_32_PKG_NAME)-pkg-install.sh

PARANOIA_32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PARANOIA_32_PKG_NAME)-package

pkg_basename     = $(PARANOIA_32_PKG_NAME)-$(PARANOIA_32_PKG_VERSION)-$(PARANOIA_32_PKG_ARCH)-$(PARANOIA_32_PKG_DISTRO_NAME)-$(PARANOIA_32_PKG_DISTRO_VERSION)

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


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --includedir=/usr/include/cdda
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

environment  = FLAGS="-g -O2"
environment += OPT="-O2 -fsigned-char $(FLAGS) -I$(TARGET_DEST_DIR)/usr/include $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS)"
environment += DEBUG="-g -Wall -fsigned-char $(FLAGS)"
environment += CC="$(CC)"
environment += LD="$(CC)"
environment += LDFLAGS="$(FLAGS)"
environment += AR="$(AR)"
environment += RANLIB="$(RANLIB)"
environment += INSTALL=install
environment += prefix=/usr
environment += exec_prefix=${prefix}
environment += BINDIR=${exec_prefix}/bin/32
environment += MANDIR=${prefix}/share/man
environment += INCLUDEDIR=${prefix}/include/cdda
environment += LIBDIR=${exec_prefix}/lib$(MULTILIB_X86_32_SUFFIX)

####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(SRC_DIR) && ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 $(environment)
	@touch $@

$(install_target): $(build_target)
	@install -d $(PARANOIA_32_PKG)/usr/bin/32
	@install -d $(PARANOIA_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(SRC_DIR) ; \
	   install -m 0755 cdparanoia $(PARANOIA_32_PKG)/usr/bin/32 ; \
	   install -m 0755 paranoia/libcdda_paranoia.so.0.10.? \
	                   interface/libcdda_interface.so.0.10.? \
	                   $(PARANOIA_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   install -m 0644 paranoia/libcdda_paranoia.a interface/libcdda_interface.a \
	                   $(PARANOIA_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   cp -a paranoia/libcdda_paranoia.so paranoia/libcdda_paranoia.so.0 \
	         interface/libcdda_interface.so interface/libcdda_interface.so.0 \
	         $(PARANOIA_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PARANOIA_32_PKG))
	# ======= Strip binaries =======
	@( cd $(PARANOIA_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(PARANOIA_32_PKG_DESCRIPTION_FILE): $(PARANOIA_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PARANOIA_32_PKG_DESCRIPTION_FILE) $(PARANOIA_32_PKG_INSTALL_SCRIPT)
	@cp $(PARANOIA_32_PKG_DESCRIPTION_FILE) $(PARANOIA_32_PKG)/.DESCRIPTION
	@cp $(PARANOIA_32_PKG_INSTALL_SCRIPT) $(PARANOIA_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PARANOIA_32_PKG)/.REQUIRES
	@echo "pkgname=$(PARANOIA_32_PKG_NAME)"                            >  $(PARANOIA_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PARANOIA_32_PKG_VERSION)"                          >> $(PARANOIA_32_PKG)/.PKGINFO ; \
	 echo "arch=$(PARANOIA_32_PKG_ARCH)"                               >> $(PARANOIA_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PARANOIA_32_PKG_DISTRO_NAME)"                  >> $(PARANOIA_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PARANOIA_32_PKG_DISTRO_VERSION)"                >> $(PARANOIA_32_PKG)/.PKGINFO ; \
	 echo "group=$(PARANOIA_32_PKG_GROUP)"                             >> $(PARANOIA_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PARANOIA_32_PKG_SHORT_DESCRIPTION)\"" >> $(PARANOIA_32_PKG)/.PKGINFO ; \
	 echo "url=$(PARANOIA_32_PKG_URL)"                                 >> $(PARANOIA_32_PKG)/.PKGINFO ; \
	 echo "license=$(PARANOIA_32_PKG_LICENSE)"                         >> $(PARANOIA_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PARANOIA_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
