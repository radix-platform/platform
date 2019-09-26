
COMPONENT_TARGETS  = $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_PPC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/gc
SOURCE_REQUIRES   += sources/packages/l/libatomic_ops

REQUIRES           = libs/gc/7.4.2
REQUIRES          += libs/glibc/2.28-ppc32

# ======= __END_OF_REQUIRES__ =======


version            = 7.4.2
libatomic_version  = 7.4.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/gc/gc-$(version)$(version_suffix).tar.gz
tar_gz_archive_ops = $(SRC_PACKAGE_PATH)/packages/l/libatomic_ops/libatomic_ops-$(libatomic_version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gc-$(version)
src_dir_name       = gc-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done
ops_src_done       = $(TARGET_BUILD_DIR)/.ops-source-done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GC_32_PKG_NAME                = gc-x32
GC_32_PKG_VERSION             = 7.4.2
GC_32_PKG_ARCH                = $(TOOLCHAIN)
GC_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GC_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GC_32_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
GC_32_PKG_SHORT_DESCRIPTION   = garbage collector library
GC_32_PKG_URL                 = $(BUG_URL)
GC_32_PKG_LICENSE             = GPLv2
GC_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GC_32_PKG_NAME)-pkg-description
GC_32_PKG_DESCRIPTION_FILE_IN = $(GC_32_PKG_NAME)-pkg-description.in
GC_32_PKG_INSTALL_SCRIPT      = $(GC_32_PKG_NAME)-pkg-install.sh

GC_32_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GC_32_PKG_NAME)-package

pkg_basename     = $(GC_32_PKG_NAME)-$(GC_32_PKG_VERSION)-$(GC_32_PKG_ARCH)-$(GC_32_PKG_DISTRO_NAME)-$(GC_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(GC_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_PPC32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-cplusplus
extra_configure_switches += --enable-large-config
extra_configure_switches += --enable-parallel-mark
extra_configure_switches += --enable-threads=posix
extra_configure_switches += --with-libatomic-ops=no
ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes

CFLAGS += -DUSE_GET_STACKBASE_FOR_MAIN


TARGET_LIB_RPATH = /lib$(MULTILIB_PPC32_SUFFIX):/usr/lib$(MULTILIB_PPC32_SUFFIX):/usr/lib/../lib$(MULTILIB_PPC32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(ops_src_done): $(src_done)
	@echo "Expanding $(tar_gz_archive_ops)"
	@tar xzf $(tar_gz_archive_ops) -C $(TARGET_BUILD_DIR)
	@cd $(SRC_DIR) ; ln -sf ../libatomic_ops-$(libatomic_version) libatomic_ops
	@( cd $(SRC_DIR) ; \
	   sed -i 's#pkgdata#doc#' doc/doc.am                    ; \
	   sed -i 's#pkgdata#doc#' libatomic_ops/Makefile.am     ; \
	   sed -i 's#pkgdata#doc#' libatomic_ops/doc/Makefile.am ; \
	   autoreconf -vif        ; \
	   automake --add-missing ; \
	 )
	@touch $@

$(build_target): $(ops_src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GC_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@cd $(build_dir)/libatomic_ops && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(GC_32_PKG)/usr/include
	@rm -rf $(GC_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GC_32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libatomic_ops.la libatomic_ops_gpl.la  \
	                                   libcord.la libgc.la libgccpp.la      ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GC_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libatomic_ops.la libatomic_ops_gpl.la  \
	                                            libcord.la libgc.la libgccpp.la      ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libatomic_ops.la libatomic_ops_gpl.la  \
	                                              libcord.la libgc.la libgccpp.la      ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" atomic_ops.pc bdw-gc.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(GC_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(GC_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GC_32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GC_32_PKG_DESCRIPTION_FILE): $(GC_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)$(version_suffix)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GC_32_PKG_DESCRIPTION_FILE) $(GC_32_PKG_INSTALL_SCRIPT)
	@cp $(GC_32_PKG_DESCRIPTION_FILE) $(GC_32_PKG)/.DESCRIPTION
	@cp $(GC_32_PKG_INSTALL_SCRIPT) $(GC_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GC_32_PKG)/.REQUIRES
	@echo "pkgname=$(GC_32_PKG_NAME)"                            >  $(GC_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GC_32_PKG_VERSION)"                          >> $(GC_32_PKG)/.PKGINFO ; \
	 echo "arch=$(GC_32_PKG_ARCH)"                               >> $(GC_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GC_32_PKG_DISTRO_NAME)"                  >> $(GC_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GC_32_PKG_DISTRO_VERSION)"                >> $(GC_32_PKG)/.PKGINFO ; \
	 echo "group=$(GC_32_PKG_GROUP)"                             >> $(GC_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GC_32_PKG_SHORT_DESCRIPTION)\"" >> $(GC_32_PKG)/.PKGINFO ; \
	 echo "url=$(GC_32_PKG_URL)"                                 >> $(GC_32_PKG)/.PKGINFO ; \
	 echo "license=$(GC_32_PKG_LICENSE)"                         >> $(GC_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GC_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
