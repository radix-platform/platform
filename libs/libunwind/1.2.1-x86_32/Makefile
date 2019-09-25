
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libunwind

REQUIRES           = libs/libunwind/1.2.1
REQUIRES          += app/xz/5.2.3-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.2.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libunwind/libunwind-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libunwind-$(version)
src_dir_name       = libunwind-$(version)
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
LIBUNWIND_32_PKG_NAME                = libunwind-x32
LIBUNWIND_32_PKG_VERSION             = 1.2.1
LIBUNWIND_32_PKG_ARCH                = $(TOOLCHAIN)
LIBUNWIND_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBUNWIND_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBUNWIND_32_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
LIBUNWIND_32_PKG_SHORT_DESCRIPTION   = platform-independent unwind API
LIBUNWIND_32_PKG_URL                 = $(BUG_URL)
LIBUNWIND_32_PKG_LICENSE             = BSD
LIBUNWIND_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBUNWIND_32_PKG_NAME)-pkg-description
LIBUNWIND_32_PKG_DESCRIPTION_FILE_IN = $(LIBUNWIND_32_PKG_NAME)-pkg-description.in
LIBUNWIND_32_PKG_INSTALL_SCRIPT      = $(LIBUNWIND_32_PKG_NAME)-pkg-install.sh

LIBUNWIND_32_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBUNWIND_32_PKG_NAME)-package

pkg_basename     = $(LIBUNWIND_32_PKG_NAME)-$(LIBUNWIND_32_PKG_VERSION)-$(LIBUNWIND_32_PKG_ARCH)-$(LIBUNWIND_32_PKG_DISTRO_NAME)-$(LIBUNWIND_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(LIBUNWIND_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --disable-documentation

ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


ARCH = x86


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; chmod 755 ./bootstrap ; ./bootstrap )
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
	@mkdir -p $(LIBUNWIND_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Save libunwind-$(ARCH).h =======
	@cp -a $(LIBUNWIND_32_PKG)/usr/include/libunwind-$(ARCH).h $(TARGET_BUILD_DIR)
ifneq ($(__ENABLE_STATIC__),yes)
	@rm -f $(LIBUNWIND_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libunwind-generic.a
endif
	@rm -rf $(LIBUNWIND_32_PKG)/usr/include
	# ======= Restore libunwind-$(ARCH).h =======
	@mkdir -p $(LIBUNWIND_32_PKG)/usr/include
	@mv $(TARGET_BUILD_DIR)/libunwind-$(ARCH).h $(LIBUNWIND_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBUNWIND_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libunwind-$(ARCH).la libunwind-coredump.la  \
	                                    libunwind-ptrace.la  libunwind-setjmp.la    \
	                                    libunwind.la                              ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBUNWIND_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libunwind-$(ARCH).la libunwind-coredump.la  \
	                                            libunwind-ptrace.la  libunwind-setjmp.la    \
	                                            libunwind.la                              ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libunwind-$(ARCH).la libunwind-coredump.la  \
	                                              libunwind-ptrace.la  libunwind-setjmp.la    \
	                                              libunwind.la                              ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libunwind-coredump.pc libunwind-generic.pc  \
	                                            libunwind-ptrace.pc   libunwind-setjmp.pc   \
	                                            libunwind.pc                              ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBUNWIND_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(LIBUNWIND_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBUNWIND_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBUNWIND_32_PKG_DESCRIPTION_FILE): $(LIBUNWIND_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBUNWIND_32_PKG_DESCRIPTION_FILE) $(LIBUNWIND_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBUNWIND_32_PKG_DESCRIPTION_FILE) $(LIBUNWIND_32_PKG)/.DESCRIPTION
	@cp $(LIBUNWIND_32_PKG_INSTALL_SCRIPT) $(LIBUNWIND_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBUNWIND_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBUNWIND_32_PKG_NAME)"                            >  $(LIBUNWIND_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBUNWIND_32_PKG_VERSION)"                          >> $(LIBUNWIND_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBUNWIND_32_PKG_ARCH)"                               >> $(LIBUNWIND_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBUNWIND_32_PKG_DISTRO_NAME)"                  >> $(LIBUNWIND_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBUNWIND_32_PKG_DISTRO_VERSION)"                >> $(LIBUNWIND_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBUNWIND_32_PKG_GROUP)"                             >> $(LIBUNWIND_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBUNWIND_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBUNWIND_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBUNWIND_32_PKG_URL)"                                 >> $(LIBUNWIND_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBUNWIND_32_PKG_LICENSE)"                         >> $(LIBUNWIND_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBUNWIND_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
