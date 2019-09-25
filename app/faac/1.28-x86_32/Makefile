
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/audiocoding/faac

REQUIRES           = app/faac/1.28
REQUIRES          += libs/mp4v2/2.0.0-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.28
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/audiocoding/faac/faac-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/faac-$(version)
src_dir_name       = faac-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
FAAC_32_PKG_NAME                = faac-x32
FAAC_32_PKG_VERSION             = 1.28
FAAC_32_PKG_ARCH                = $(TOOLCHAIN)
FAAC_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FAAC_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FAAC_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
FAAC_32_PKG_SHORT_DESCRIPTION   = MPEG-4 and MPEG-2 AAC encoder
FAAC_32_PKG_URL                 = $(BUG_URL)
FAAC_32_PKG_LICENSE             = LGPLv2
FAAC_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FAAC_32_PKG_NAME)-pkg-description
FAAC_32_PKG_DESCRIPTION_FILE_IN = $(FAAC_32_PKG_NAME)-pkg-description.in
FAAC_32_PKG_INSTALL_SCRIPT      = $(FAAC_32_PKG_NAME)-pkg-install.sh

FAAC_32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FAAC_32_PKG_NAME)-package

pkg_basename      = $(FAAC_32_PKG_NAME)-$(FAAC_32_PKG_VERSION)-$(FAAC_32_PKG_ARCH)-$(FAAC_32_PKG_DISTRO_NAME)-$(FAAC_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(FAAC_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --with-pic

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


CXXFLAGS += -Wno-write-strings -Wno-address


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   ./bootstrap ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(FAAC_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(FAAC_32_PKG)/usr/include
	@rm -rf $(FAAC_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(FAAC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libfaac.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FAAC_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libfaac.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libfaac.la \
	 )
	# ======= Strip binaries =======
	@( cd $(FAAC_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(FAAC_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(FAAC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(FAAC_32_PKG_DESCRIPTION_FILE): $(FAAC_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FAAC_32_PKG_DESCRIPTION_FILE) $(FAAC_32_PKG_INSTALL_SCRIPT)
	@cp $(FAAC_32_PKG_DESCRIPTION_FILE) $(FAAC_32_PKG)/.DESCRIPTION
	@cp $(FAAC_32_PKG_INSTALL_SCRIPT) $(FAAC_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FAAC_32_PKG)/.REQUIRES
	@echo "pkgname=$(FAAC_32_PKG_NAME)"                            >  $(FAAC_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FAAC_32_PKG_VERSION)"                          >> $(FAAC_32_PKG)/.PKGINFO ; \
	 echo "arch=$(FAAC_32_PKG_ARCH)"                               >> $(FAAC_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(FAAC_32_PKG_DISTRO_NAME)"                  >> $(FAAC_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(FAAC_32_PKG_DISTRO_VERSION)"                >> $(FAAC_32_PKG)/.PKGINFO ; \
	 echo "group=$(FAAC_32_PKG_GROUP)"                             >> $(FAAC_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FAAC_32_PKG_SHORT_DESCRIPTION)\"" >> $(FAAC_32_PKG)/.PKGINFO ; \
	 echo "url=$(FAAC_32_PKG_URL)"                                 >> $(FAAC_32_PKG)/.PKGINFO ; \
	 echo "license=$(FAAC_32_PKG_LICENSE)"                         >> $(FAAC_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(FAAC_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
