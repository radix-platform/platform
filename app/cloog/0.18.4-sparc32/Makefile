
COMPONENT_TARGETS  = $(HARDWARE_MBC4_PC)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_SPARC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/CLooG

REQUIRES           = app/cloog/0.18.4
REQUIRES          += libs/isl/0.18-sparc32

# ======= __END_OF_REQUIRES__ =======


version            = 0.18.4
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/CLooG/cloog-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/cloog-$(version)
src_dir_name       = cloog-$(version)
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
CLOOG_32_PKG_NAME                = cloog-x32
CLOOG_32_PKG_VERSION             = 0.18.4
CLOOG_32_PKG_ARCH                = $(TOOLCHAIN)
CLOOG_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CLOOG_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CLOOG_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
CLOOG_32_PKG_SHORT_DESCRIPTION   = The Chunky Loop Generator
CLOOG_32_PKG_URL                 = $(BUG_URL)
CLOOG_32_PKG_LICENSE             = GPLv2
CLOOG_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CLOOG_32_PKG_NAME)-pkg-description
CLOOG_32_PKG_DESCRIPTION_FILE_IN = $(CLOOG_32_PKG_NAME)-pkg-description.in
CLOOG_32_PKG_INSTALL_SCRIPT      = $(CLOOG_32_PKG_NAME)-pkg-install.sh

CLOOG_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CLOOG_32_PKG_NAME)-package

pkg_basename     = $(CLOOG_32_PKG_NAME)-$(CLOOG_32_PKG_VERSION)-$(CLOOG_32_PKG_ARCH)-$(CLOOG_32_PKG_DISTRO_NAME)-$(CLOOG_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(CLOOG_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_SPARC32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --with-gnu-ld
extra_configure_switches += --with-bits=gmp
extra_configure_switches += --with-gmp=system
extra_configure_switches += --with-isl=system
extra_configure_switches += --with-osl=no
ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


TARGET_BIN_RPATH = /lib$(MULTILIB_SPARC32_SUFFIX):/usr/lib$(MULTILIB_SPARC32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_SPARC32_SUFFIX):/usr/lib$(MULTILIB_SPARC32_SUFFIX):/usr/lib/../lib$(MULTILIB_SPARC32_SUFFIX)


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
	@mkdir -p $(CLOOG_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(CLOOG_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(CLOOG_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   sed -i "s,-L/lib,,g" libcloog-isl.la ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcloog-isl.la \
	 )
	# ======= remove toolchain path from target pkg-config *.pc files =======
	@( cd $(CLOOG_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,-L/lib,,g" cloog-isl.pc ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" cloog-isl.pc \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(CLOOG_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcloog-isl.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcloog-isl.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" cloog-isl.pc ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" cloog-isl.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(CLOOG_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(CLOOG_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(CLOOG_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(CLOOG_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(CLOOG_32_PKG_DESCRIPTION_FILE): $(CLOOG_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CLOOG_32_PKG_DESCRIPTION_FILE) $(CLOOG_32_PKG_INSTALL_SCRIPT)
	@cp $(CLOOG_32_PKG_DESCRIPTION_FILE) $(CLOOG_32_PKG)/.DESCRIPTION
	@cp $(CLOOG_32_PKG_INSTALL_SCRIPT) $(CLOOG_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CLOOG_32_PKG)/.REQUIRES
	@echo "pkgname=$(CLOOG_32_PKG_NAME)"                            >  $(CLOOG_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CLOOG_32_PKG_VERSION)"                          >> $(CLOOG_32_PKG)/.PKGINFO ; \
	 echo "arch=$(CLOOG_32_PKG_ARCH)"                               >> $(CLOOG_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(CLOOG_32_PKG_DISTRO_NAME)"                  >> $(CLOOG_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(CLOOG_32_PKG_DISTRO_VERSION)"                >> $(CLOOG_32_PKG)/.PKGINFO ; \
	 echo "group=$(CLOOG_32_PKG_GROUP)"                             >> $(CLOOG_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CLOOG_32_PKG_SHORT_DESCRIPTION)\"" >> $(CLOOG_32_PKG)/.PKGINFO ; \
	 echo "url=$(CLOOG_32_PKG_URL)"                                 >> $(CLOOG_32_PKG)/.PKGINFO ; \
	 echo "license=$(CLOOG_32_PKG_LICENSE)"                         >> $(CLOOG_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(CLOOG_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
