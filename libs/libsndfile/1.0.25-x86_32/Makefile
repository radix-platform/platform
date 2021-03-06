
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/mega-nerd/libsndfile

REQUIRES           = libs/libsndfile/1.0.25
REQUIRES          += libs/alsa-lib/1.1.1-x86_32
REQUIRES          += libs/libvorbis/1.3.5-x86_32
REQUIRES          += libs/libogg/1.3.2-x86_32
REQUIRES          += app/flac/1.3.1-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.25
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/mega-nerd/libsndfile/libsndfile-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libsndfile-$(version)
src_dir_name       = libsndfile-$(version)
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
LIBSNDFILE_32_PKG_NAME                = libsndfile-x32
LIBSNDFILE_32_PKG_VERSION             = 1.0.25
LIBSNDFILE_32_PKG_ARCH                = $(TOOLCHAIN)
LIBSNDFILE_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBSNDFILE_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBSNDFILE_32_PKG_GROUP               = $(PKG_GROUP)
###                                    |---handy-ruler-------------------------------|
LIBSNDFILE_32_PKG_SHORT_DESCRIPTION   = C library for reading and writing wav files
LIBSNDFILE_32_PKG_URL                 = $(BUG_URL)
LIBSNDFILE_32_PKG_LICENSE             = LGPLv2.1
LIBSNDFILE_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBSNDFILE_32_PKG_NAME)-pkg-description
LIBSNDFILE_32_PKG_DESCRIPTION_FILE_IN = $(LIBSNDFILE_32_PKG_NAME)-pkg-description.in
LIBSNDFILE_32_PKG_INSTALL_SCRIPT      = $(LIBSNDFILE_32_PKG_NAME)-pkg-install.sh

LIBSNDFILE_32_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBSNDFILE_32_PKG_NAME)-package

pkg_basename      = $(LIBSNDFILE_32_PKG_NAME)-$(LIBSNDFILE_32_PKG_VERSION)-$(LIBSNDFILE_32_PKG_ARCH)-$(LIBSNDFILE_32_PKG_DISTRO_NAME)-$(LIBSNDFILE_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBSNDFILE_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --htmldir=/usr/share/doc/$(src_dir_name)/html
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --disable-sqlite
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

environment = htmldocdir=/usr/share/doc/$(src_dir_name)/html


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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBSNDFILE_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(environment) $(env_sysroot)
	@mkdir -p $(LIBSNDFILE_32_PKG)/usr/bin/32
	@( cd $(LIBSNDFILE_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(LIBSNDFILE_32_PKG)/usr/include
	@rm -rf $(LIBSNDFILE_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBSNDFILE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libsndfile.la  \
	 )
	# ======= remove toolchain path from target *.pc files =======
	@( cd $(LIBSNDFILE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" sndfile.pc  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBSNDFILE_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsndfile.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libsndfile.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" sndfile.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBSNDFILE_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(LIBSNDFILE_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBSNDFILE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBSNDFILE_32_PKG_DESCRIPTION_FILE): $(LIBSNDFILE_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBSNDFILE_32_PKG_DESCRIPTION_FILE) $(LIBSNDFILE_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBSNDFILE_32_PKG_DESCRIPTION_FILE) $(LIBSNDFILE_32_PKG)/.DESCRIPTION
	@cp $(LIBSNDFILE_32_PKG_INSTALL_SCRIPT) $(LIBSNDFILE_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBSNDFILE_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBSNDFILE_32_PKG_NAME)"                            >  $(LIBSNDFILE_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBSNDFILE_32_PKG_VERSION)"                          >> $(LIBSNDFILE_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBSNDFILE_32_PKG_ARCH)"                               >> $(LIBSNDFILE_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBSNDFILE_32_PKG_DISTRO_NAME)"                  >> $(LIBSNDFILE_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBSNDFILE_32_PKG_DISTRO_VERSION)"                >> $(LIBSNDFILE_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBSNDFILE_32_PKG_GROUP)"                             >> $(LIBSNDFILE_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBSNDFILE_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBSNDFILE_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBSNDFILE_32_PKG_URL)"                                 >> $(LIBSNDFILE_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBSNDFILE_32_PKG_LICENSE)"                         >> $(LIBSNDFILE_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBSNDFILE_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
