
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_DM64X)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/CLooG

REQUIRES           = libs/gmp/6.0.0

# ======= __END_OF_REQUIRES__ =======


version            = 0.18.2
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
CLOOG_PKG_NAME                = cloog
CLOOG_PKG_VERSION             = 0.18.2
CLOOG_PKG_ARCH                = $(TOOLCHAIN)
CLOOG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CLOOG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CLOOG_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
CLOOG_PKG_SHORT_DESCRIPTION   = The Chunky Loop Generator
CLOOG_PKG_URL                 = $(BUG_URL)
CLOOG_PKG_LICENSE             = GPLv2
CLOOG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CLOOG_PKG_NAME)-pkg-description
CLOOG_PKG_DESCRIPTION_FILE_IN = $(CLOOG_PKG_NAME)-pkg-description.in
CLOOG_PKG_INSTALL_SCRIPT      = $(CLOOG_PKG_NAME)-pkg-install.sh

CLOOG_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CLOOG_PKG_NAME)-package

pkg_basename     = $(CLOOG_PKG_NAME)-$(CLOOG_PKG_VERSION)-$(CLOOG_PKG_ARCH)-$(CLOOG_PKG_DISTRO_NAME)-$(CLOOG_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))


BUILD_TARGETS    = $(build_cloog_pkg)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(CLOOG_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --with-gnu-ld
extra_configure_switches += --with-bits=gmp
extra_configure_switches += --with-gmp=system
extra_configure_switches += --with-isl=bundled
extra_configure_switches += --with-osl=no
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes



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
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(CLOOG_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -f $(CLOOG_PKG)/usr/lib$(LIBSUFFIX)/libisl.so.*-gdb.py
	# ======= Install Documentation =======
	@mkdir -p $(CLOOG_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/README \
	       $(CLOOG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(CLOOG_PKG)/usr/share/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/CLOOG_HEAD $(SRC_DIR)/README $(SRC_DIR)/doc/TODO $(SRC_DIR)/doc/cloog.pdf \
	       $(CLOOG_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(CLOOG_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(CLOOG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,-L/lib,,g" libcloog-isl.la ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcloog-isl.la libisl.la \
	 )
	# ======= remove toolchain path from target pkg-config *.pc files =======
	@( cd $(CLOOG_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,-L/lib,,g" cloog-isl.pc ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" cloog-isl.pc isl.pc \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(CLOOG_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcloog-isl.la libisl.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcloog-isl.la libisl.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" cloog-isl.pc isl.pc ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" cloog-isl.pc isl.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(CLOOG_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(CLOOG_PKG_DESCRIPTION_FILE): $(CLOOG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CLOOG_PKG_DESCRIPTION_FILE) $(CLOOG_PKG_INSTALL_SCRIPT)
	@cp $(CLOOG_PKG_DESCRIPTION_FILE) $(CLOOG_PKG)/.DESCRIPTION
	@cp $(CLOOG_PKG_INSTALL_SCRIPT) $(CLOOG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CLOOG_PKG)/.REQUIRES
	@echo "pkgname=$(CLOOG_PKG_NAME)"                            >  $(CLOOG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CLOOG_PKG_VERSION)"                          >> $(CLOOG_PKG)/.PKGINFO ; \
	 echo "arch=$(CLOOG_PKG_ARCH)"                               >> $(CLOOG_PKG)/.PKGINFO ; \
	 echo "distroname=$(CLOOG_PKG_DISTRO_NAME)"                  >> $(CLOOG_PKG)/.PKGINFO ; \
	 echo "distrover=$(CLOOG_PKG_DISTRO_VERSION)"                >> $(CLOOG_PKG)/.PKGINFO ; \
	 echo "group=$(CLOOG_PKG_GROUP)"                             >> $(CLOOG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CLOOG_PKG_SHORT_DESCRIPTION)\"" >> $(CLOOG_PKG)/.PKGINFO ; \
	 echo "url=$(CLOOG_PKG_URL)"                                 >> $(CLOOG_PKG)/.PKGINFO ; \
	 echo "license=$(CLOOG_PKG_LICENSE)"                         >> $(CLOOG_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(CLOOG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
