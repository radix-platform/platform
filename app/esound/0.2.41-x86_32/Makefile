
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNOME/core/esound

REQUIRES           = app/esound/0.2.41
REQUIRES          += libs/audiofile/0.3.6-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.2.41
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/GNOME/core/esound/esound-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/esound-$(version)
src_dir_name       = esound-$(version)
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
ESOUND_32_PKG_NAME                  = esound-x32
ESOUND_32_PKG_VERSION               = 0.2.41
ESOUND_32_PKG_ARCH                  = $(TOOLCHAIN)
ESOUND_32_PKG_DISTRO_NAME           = $(DISTRO_NAME)
ESOUND_32_PKG_DISTRO_VERSION        = $(DISTRO_VERSION)
ESOUND_32_PKG_GROUP                 = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
ESOUND_32_PKG_SHORT_DESCRIPTION     = Enlightened Sound Daemon
ESOUND_32_PKG_URL                   = $(BUG_URL)
ESOUND_32_PKG_LICENSE               = LibGPLv2
ESOUND_32_PKG_DESCRIPTION_FILE      = $(TARGET_BUILD_DIR)/$(ESOUND_32_PKG_NAME)-pkg-description
ESOUND_32_PKG_DESCRIPTION_ESOUND_IN = $(ESOUND_32_PKG_NAME)-pkg-description.in
ESOUND_32_PKG_INSTALL_SCRIPT        = $(ESOUND_32_PKG_NAME)-pkg-install.sh

ESOUND_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ESOUND_32_PKG_NAME)-package

pkg_basename     = $(ESOUND_32_PKG_NAME)-$(ESOUND_32_PKG_VERSION)-$(ESOUND_32_PKG_ARCH)-$(ESOUND_32_PKG_DISTRO_NAME)-$(ESOUND_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))


BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(ESOUND_32_PKG)

extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --program-prefix=
extra_configure_switches += --program-suffix=
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
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ESOUND_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(ESOUND_32_PKG)/usr/bin/32
	@( cd $(ESOUND_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(ESOUND_32_PKG)/etc
	@rm -rf $(ESOUND_32_PKG)/usr/include
	@rm -rf $(ESOUND_32_PKG)/usr/share
	# ======= remove target path from target libtool *.la files =======
	@( cd $(ESOUND_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libesd.la libesddsp.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ESOUND_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libesd.la libesddsp.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libesd.la libesddsp.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" esound.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(ESOUND_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(ESOUND_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(ESOUND_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(ESOUND_32_PKG_DESCRIPTION_FILE): $(ESOUND_32_PKG_DESCRIPTION_ESOUND_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ESOUND_32_PKG_DESCRIPTION_FILE) $(ESOUND_32_PKG_INSTALL_SCRIPT)
	@cp $(ESOUND_32_PKG_DESCRIPTION_FILE) $(ESOUND_32_PKG)/.DESCRIPTION
	@cp $(ESOUND_32_PKG_INSTALL_SCRIPT) $(ESOUND_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ESOUND_32_PKG)/.REQUIRES
	@echo "pkgname=$(ESOUND_32_PKG_NAME)"                            >  $(ESOUND_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ESOUND_32_PKG_VERSION)"                          >> $(ESOUND_32_PKG)/.PKGINFO ; \
	 echo "arch=$(ESOUND_32_PKG_ARCH)"                               >> $(ESOUND_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(ESOUND_32_PKG_DISTRO_NAME)"                  >> $(ESOUND_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(ESOUND_32_PKG_DISTRO_VERSION)"                >> $(ESOUND_32_PKG)/.PKGINFO ; \
	 echo "group=$(ESOUND_32_PKG_GROUP)"                             >> $(ESOUND_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ESOUND_32_PKG_SHORT_DESCRIPTION)\"" >> $(ESOUND_32_PKG)/.PKGINFO ; \
	 echo "url=$(ESOUND_32_PKG_URL)"                                 >> $(ESOUND_32_PKG)/.PKGINFO ; \
	 echo "license=$(ESOUND_32_PKG_LICENSE)"                         >> $(ESOUND_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(ESOUND_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
