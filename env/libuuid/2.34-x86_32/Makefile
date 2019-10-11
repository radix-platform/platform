
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/util-linux

REQUIRES           = env/libuuid/2.34
REQUIRES          += libs/glibc/2.28-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.34
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/util-linux/util-linux-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/util-linux-$(version)
src_dir_name       = util-linux-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

LIBUUID_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/libuuid-x32-package

BUILD_TARGETS      = $(build_target)
BUILD_TARGETS     += $(install_target)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBUUID_32_PKG)


extra_configure_switches  = --libdir=/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-libuuid

ifneq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --disable-static
endif


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(python_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBUUID_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(LIBUUID_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/lib*.so.1.* . ; \
	   ln -sf libuuid.so.1.*      libuuid.so.1      ; \
	   rm -f lib*.so ; \
	   ln -sf libuuid.so.1      libuuid.so      ; \
	 )
	@rm -rf $(LIBUUID_32_PKG)/usr/include
	@rm -rf $(LIBUUID_32_PKG)/usr/share
	# ======= remove target dest dir from target libtool *.la files =======
	@( cd $(LIBUUID_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libuuid.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBUUID_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libuuid.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libuuid.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" uuid.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBUUID_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(LIBUUID_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@
