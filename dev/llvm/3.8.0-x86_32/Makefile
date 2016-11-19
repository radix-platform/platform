
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

NOT_PARALLEL       = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/LLVM

REQUIRES           = dev/llvm/3.8.0
REQUIRES          += libs/libxml2/2.9.3-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 3.8.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/d/LLVM/llvm/llvm-$(version).src.tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/llvm-$(version).src
src_dir_name       = llvm-$(version).src
doc_dir_name       = llvm-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

cfe_xz_archive         = $(SRC_PACKAGE_PATH)/packages/d/LLVM/cfe/cfe-$(version).src.tar.xz
extra_tools_xz_archive = $(SRC_PACKAGE_PATH)/packages/d/LLVM/extra-tools/clang-tools-extra-$(version).src.tar.xz
compiler_rt_xz_archive = $(SRC_PACKAGE_PATH)/packages/d/LLVM/compiler-rt/compiler-rt-$(version).src.tar.xz

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LLVM_32_PKG_NAME                = llvm-x32
LLVM_32_PKG_VERSION             = 3.8.0
LLVM_32_PKG_ARCH                = $(TOOLCHAIN)
LLVM_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LLVM_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LLVM_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
LLVM_32_PKG_SHORT_DESCRIPTION   = LLVM compiler toolkit
LLVM_32_PKG_URL                 = $(BUG_URL)
LLVM_32_PKG_LICENSE             = custom
LLVM_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LLVM_32_PKG_NAME)-pkg-description
LLVM_32_PKG_DESCRIPTION_FILE_IN = $(LLVM_32_PKG_NAME)-pkg-description.in
LLVM_32_PKG_INSTALL_SCRIPT      = $(LLVM_32_PKG_NAME)-pkg-install.sh

LLVM_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LLVM_32_PKG_NAME)-package

pkg_basename     = $(LLVM_32_PKG_NAME)-$(LLVM_32_PKG_VERSION)-$(LLVM_32_PKG_ARCH)-$(LLVM_32_PKG_DISTRO_NAME)-$(LLVM_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LLVM_32_PKG)

LLVM_JOBS = -j$(NUMPROCS)

TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)

configure_switches  = -DBUG_REPORT_URL='http://llvm.org'

configure_switches += -DCMAKE_C_COMPILER='$(CROSS_PREFIX)gcc'
configure_switches += -DCMAKE_CXX_COMPILER='$(CROSS_PREFIX)g++'
#
# CMAKE passes the same {ASM|C}_DEFINES to the C and ASM compilers
# by the SET(CMAKE_TARGET_DEFINITIONS ..) function.  This is a bad
# practice for GNU Assembler.  GNU AS  compiler doesn't understand
# options like -D_GNU_SOURCE .
#
configure_switches += -DCMAKE_ASM_COMPILER='$(CROSS_PREFIX)gcc'

configure_switches += -DCMAKE_LINKER='$(CROSS_PREFIX)ld'
configure_switches += -DGOLD_EXECUTABLE='$(CROSS_PREFIX)ld.gold'
configure_switches += -DCMAKE_AR='$(CROSS_PREFIX)ar'
configure_switches += -DCMAKE_NM='$(CROSS_PREFIX)nm'
configure_switches += -DCMAKE_RANLIB='$(CROSS_PREFIX)ranlib'
configure_switches += -DCMAKE_OBJCOPY='$(CROSS_PREFIX)objcopy'
configure_switches += -DCMAKE_OBJDUMP='$(CROSS_PREFIX)objdump'
configure_switches += -DCMAKE_STRIP='$(CROSS_PREFIX)strip'

configure_switches += -DCMAKE_C_FLAGS:STRING='--sysroot=$(TARGET_DEST_DIR) -m32 $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS)'
configure_switches += -DCMAKE_CXX_FLAGS:STRING='--sysroot=$(TARGET_DEST_DIR) -m32 $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS)'

configure_switches += -DCMAKE_EXE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 -Wl,-rpath,$(TARGET_BIN_RPATH) -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)'
configure_switches += -DCMAKE_MODULE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)'
configure_switches += -DCMAKE_SHARED_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)'

configure_switches += -DCMAKE_SKIP_INSTALL_RPATH=NO
configure_switches += -DCMAKE_SKIP_RPATH=YES

configure_switches += -DCMAKE_INSTALL_PREFIX=/usr
configure_switches += -DCMAKE_INSTALL_BINDIR=bin/32
configure_switches += -DCMAKE_INSTALL_LIBDIR=lib$(MULTILIB_X86_32_SUFFIX)
configure_switches += -DCMAKE_INSTALL_LIBEXECDIR=libexec/32
configure_switches += -DCMAKE_INSTALL_DOCDIR='share/doc/$(doc_dir_name)'

configure_switches += -DLLVM_LIBDIR_SUFFIX=$(MULTILIB_X86_32_SUFFIX)

configure_switches += -DCMAKE_BUILD_TYPE=Release
configure_switches += -DLLVM_BUILD_LLVM_DYLIB=ON
configure_switches += -DLLVM_LINK_LLVM_DYLIB=ON
configure_switches += -DLLVM_ENABLE_RTTI=ON
configure_switches += -DLLVM_ENABLE_FFI=ON
configure_switches += -DLLVM_ENABLE_ZLIB=ON
configure_switches += -DLLVM_ENABLE_ASSERTIONS=OFF
configure_switches += -DLLVM_ENABLE_PIC=ON
configure_switches += -DCLANG_RESOURCE_DIR='../../lib$(MULTILIB_X86_32_SUFFIX)/clang/$(version)'

configure_switches += -DFFI_INCLUDE_DIR=$(TARGET_DEST_DIR)/usr/include
configure_switches += -DFFI_LIBRARY_PATH=$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libffi.so

configure_switches += -DLLVM_BUILD_DOCS=OFF

configure_switches += -DCMAKE_CROSSCOMPILING=True

configure_switches += -DLLVM_DEFAULT_TARGET_TRIPLE=$(TARGET32)
configure_switches += -DCOMPILER_RT_DEFAULT_TARGET_TRIPLE=$(TARGET32)
configure_switches += -DLLVM_HOST_TRIPLE=$(TARGET32)

configure_switches += -DLLVM_TABLEGEN=$(CURDIR)/$(TARGET_BUILD_DIR)/build-machine/bin/llvm-tblgen
configure_switches += -DCLANG_TABLEGEN=$(CURDIR)/$(TARGET_BUILD_DIR)/build-machine/bin/clang-tblgen

configure_switches += -DLLVM_PARALLEL_COMPILE_JOBS=$(NUMPROCS)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	@echo "Expanding $(cfe_xz_archive)"
	@tar xJf $(cfe_xz_archive)         -C $(TARGET_BUILD_DIR)
	@echo "Expanding $(extra_tools_xz_archive)"
	@tar xJf $(extra_tools_xz_archive) -C $(TARGET_BUILD_DIR)/cfe-$(version).src/tools
	@( cd $(TARGET_BUILD_DIR)/cfe-$(version).src/tools ; \
	   mv clang-tools-extra-$(version).src extra ; \
	 )
	@echo "Expanding $(compiler_rt_xz_archive)"
	@tar xJf $(compiler_rt_xz_archive) -C $(TARGET_BUILD_DIR)
	@( cd $(SRC_DIR)/tools ; \
	   ln -sf ../../cfe-$(version).src clang ; \
	 )
	@( cd $(SRC_DIR)/projects ; \
	   ln -sf ../../compiler-rt-$(version).src compiler-rt ; \
	 )
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(TARGET_BUILD_DIR)/build-machine
	@( cd $(TARGET_BUILD_DIR)/build-machine ; \
	   cmake -DCMAKE_BUILD_TYPE=Release \
	         -DLLVM_LIBDIR_SUFFIX=$(MULTILIB_X86_32_SUFFIX) ../llvm-$(version).src ; \
	   $(MAKE) $(LLVM_JOBS)  llvm-tblgen ; \
	   $(MAKE) $(LLVM_JOBS) clang-tblgen ; \
	   $(MAKE) $(LLVM_JOBS)  llvm-config ; \
	 )
	@mkdir -p $(build_dir)
	@( cd $(build_dir) ; \
	   $(BUILD_ENVIRONMENT) cmake $(configure_switches) ../llvm-$(version).src ; \
	 )
	@( cd $(build_dir) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) $(LLVM_JOBS) ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LLVM_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(LLVM_32_PKG)/usr/bin ; \
	   ln -sf clang   $(TARGET32)-clang   ; \
	   ln -sf clang++ $(TARGET32)-clang++ ; \
	 )
	# ======= Move 32-Bit binaries into /usr/bin/32 directory =======
	@mkdir -p $(LLVM_32_PKG)/usr/bin/32
	@( cd $(LLVM_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	   find . -type l | xargs mv -t 32 ; \
	 )
	# ======= Install $(TARGET32)-llvm-config =======
	@( cd $(TARGET_BUILD_DIR)/build-machine/bin ; \
	   cp -a llvm-config $(LLVM_32_PKG)/usr/bin/$(TARGET32)-llvm-config ; \
	 )
	# ======= Save config.h and llvm-config.h =======
	@for header in config ; do \
	   cp -a $(LLVM_32_PKG)/usr/include/clang/Config/$$header.h $(TARGET_BUILD_DIR) ; \
	 done
	@for header in llvm-config ; do \
	   cp -a $(LLVM_32_PKG)/usr/include/llvm/Config/$$header.h $(TARGET_BUILD_DIR) ; \
	 done
	@rm -rf $(LLVM_32_PKG)/usr/include
	@rm -rf $(LLVM_32_PKG)/usr/libexec
	@rm -rf $(LLVM_32_PKG)/usr/share
	# ======= Restore config-32.h and llvm-config-32.h =======
	@mkdir -p $(LLVM_32_PKG)/usr/include/{clang,llvm}/Config
	@for header in config ; do \
	   cp -a $(TARGET_BUILD_DIR)/$$header.h $(LLVM_32_PKG)/usr/include/clang/Config/$$header-32.h ; \
	 done
	@for header in llvm-config ; do \
	   cp -a $(TARGET_BUILD_DIR)/$$header.h $(LLVM_32_PKG)/usr/include/llvm/Config/$$header-32.h ; \
	 done
	# ======= Install Python bindings =======
	@mkdir -p $(LLVM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python2.7/site-packages
	@cp -a $(SRC_DIR)/tools/clang/bindings/python/clang $(LLVM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python2.7/site-packages
	@if [ -x /usr/bin/python2.7 ] ; then \
	   /usr/bin/python2.7 -m compileall $(LLVM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python2.7/site-packages/clang    ; \
	   /usr/bin/python2.7 -O -m compileall $(LLVM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python2.7/site-packages/clang ; \
	 fi
	# ======= Remove example libraries =======
	@rm -f $(LLVM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/LLVMHello*
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LLVM_32_PKG))
	# ======= Remove $(TARGET32)-llvm-config from target package =======
	@rm -f $(LLVM_32_PKG)/usr/bin/$(TARGET32)-llvm-config
	# ======= Strip Binaries =======
	@( cd $(LLVM_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LLVM_32_PKG_DESCRIPTION_FILE): $(LLVM_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LLVM_32_PKG_DESCRIPTION_FILE) $(LLVM_32_PKG_INSTALL_SCRIPT)
	@cp $(LLVM_32_PKG_DESCRIPTION_FILE) $(LLVM_32_PKG)/.DESCRIPTION
	@cp $(LLVM_32_PKG_INSTALL_SCRIPT) $(LLVM_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LLVM_32_PKG)/.REQUIRES
	@echo "pkgname=$(LLVM_32_PKG_NAME)"                            >  $(LLVM_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LLVM_32_PKG_VERSION)"                          >> $(LLVM_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LLVM_32_PKG_ARCH)"                               >> $(LLVM_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LLVM_32_PKG_DISTRO_NAME)"                  >> $(LLVM_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LLVM_32_PKG_DISTRO_VERSION)"                >> $(LLVM_32_PKG)/.PKGINFO ; \
	 echo "group=$(LLVM_32_PKG_GROUP)"                             >> $(LLVM_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LLVM_32_PKG_SHORT_DESCRIPTION)\"" >> $(LLVM_32_PKG)/.PKGINFO ; \
	 echo "url=$(LLVM_32_PKG_URL)"                                 >> $(LLVM_32_PKG)/.PKGINFO ; \
	 echo "license=$(LLVM_32_PKG_LICENSE)"                         >> $(LLVM_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LLVM_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
