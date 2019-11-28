
COMPONENT_TARGETS  = $(HARDWARE_MBC4_PC)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_SPARC32_PACKAGE = true

NOT_PARALLEL       = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/LLVM

REQUIRES           = dev/llvm/9.0.0
REQUIRES          += libs/libffi/3.2.1-sparc32
REQUIRES          += libs/libedit/20191025-3.1-sparc32
REQUIRES          += libs/libxml2/2.9.9-sparc32
REQUIRES          += libs/ncurses/6.1-sparc32
REQUIRES          += dev/python2/2.7.16-sparc32
REQUIRES          += dev/python3/3.7.4-sparc32

# ======= __END_OF_REQUIRES__ =======


version            = 9.0.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/d/LLVM/llvm/llvm-$(version).src.tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/llvm-$(version).src
src_dir_name       = llvm-$(version).src
doc_dir_name       = llvm-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

cfe_xz_archive         = $(SRC_PACKAGE_PATH)/packages/d/LLVM/cfe/cfe-$(version).src.tar.xz
extra_tools_xz_archive = $(SRC_PACKAGE_PATH)/packages/d/LLVM/extra-tools/clang-tools-extra-$(version).src.tar.xz
compiler_rt_xz_archive = $(SRC_PACKAGE_PATH)/packages/d/LLVM/compiler-rt/compiler-rt-$(version).src.tar.xz

lld_xz_archive         = $(SRC_PACKAGE_PATH)/packages/d/LLVM/lld/lld-$(version).src.tar.xz
polly_xz_archive       = $(SRC_PACKAGE_PATH)/packages/d/LLVM/polly/polly-$(version).src.tar.xz

openmp_xz_archive      = $(SRC_PACKAGE_PATH)/packages/d/LLVM/openmp/openmp-$(version).src.tar.xz
libcxx_xz_archive      = $(SRC_PACKAGE_PATH)/packages/d/LLVM/libcxx/libcxx-$(version).src.tar.xz
libcxxabi_xz_archive   = $(SRC_PACKAGE_PATH)/packages/d/LLVM/libcxxabi/libcxxabi-$(version).src.tar.xz
libunwind_xz_archive   = $(SRC_PACKAGE_PATH)/packages/d/LLVM/libunwind/libunwind-$(version).src.tar.xz

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
LLVM_32_PKG_VERSION             = 9.0.0
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
pkg_certificate  = $(call cert-name,$(pkg_archive))
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


ENABLE_LIBCXX    = ON
ENABLE_LIBCXXABI = ON
ENABLE_LIBUNWIND = OFF
ENABLE_LLD       = ON
ENABLE_OPENMP    = OFF
ENABLE_POLLY     = ON


TARGET_BIN_RPATH = /lib$(MULTILIB_SPARC32_SUFFIX):/usr/lib$(MULTILIB_SPARC32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_SPARC32_SUFFIX):/usr/lib$(MULTILIB_SPARC32_SUFFIX):/usr/lib/../lib$(MULTILIB_SPARC32_SUFFIX)

CFLAGS += -Wno-unused-variable -Wno-unused-function -Wno-type-limits \
          -Wno-attributes -Wno-ignored-attributes -Wno-conversion    \
          -Wno-deprecated-declarations -Wno-unused-but-set-parameter \
          -Wno-strict-aliasing -Wno-shadow -Wno-address -Wno-extra   \
          -Wno-vla -Wno-unused-but-set-variable

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

configure_switches += -DCMAKE_EXE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 -Wl,-rpath,$(TARGET_BIN_RPATH) -L$(TARGET_DEST_DIR)/lib$(MULTILIB_SPARC32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)'
configure_switches += -DCMAKE_MODULE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(MULTILIB_SPARC32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)'
configure_switches += -DCMAKE_SHARED_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(MULTILIB_SPARC32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)'

configure_switches += -DCMAKE_SKIP_INSTALL_RPATH=NO
configure_switches += -DCMAKE_SKIP_RPATH=YES

configure_switches += -DLLVM_CCACHE_BUILD=ON
configure_switches += -DCCACHE_PROGRAM=$(CCACHE)
configure_switches += -DLLVM_CCACHE_DIR:STRING='$(CACHED_CC_OUTPUT)'
configure_switches += -DLLVM_CCACHE_PARAMS:STRING='CCACHE_CPP2=yes CCACHE_HASHDIR=yes CCACHE_BASEDIR=$(CCACHE_BASEDIR)'

configure_switches += -DCMAKE_SYSTEM_NAME:STRING='Linux'

configure_switches += -DCMAKE_INSTALL_PREFIX=/usr
configure_switches += -DCMAKE_INSTALL_BINDIR=bin/32
configure_switches += -DCMAKE_INSTALL_LIBDIR=lib$(MULTILIB_SPARC32_SUFFIX)
configure_switches += -DCMAKE_INSTALL_LIBEXECDIR=libexec/32
configure_switches += -DCMAKE_INSTALL_DOCDIR='share/doc/$(doc_dir_name)'

configure_switches += -DLLVM_LIBDIR_SUFFIX=$(MULTILIB_SPARC32_SUFFIX)

configure_switches += -DCMAKE_BUILD_TYPE=Release
configure_switches += -DBUILD_SHARED_LIBS=ON
configure_switches += -DLLVM_ENABLE_RTTI=ON
configure_switches += -DLLVM_ENABLE_FFI=ON
configure_switches += -DLLVM_ENABLE_ZLIB=ON
configure_switches += -DLLVM_ENABLE_ASSERTIONS=OFF
configure_switches += -DLLVM_INSTALL_UTILS=ON
configure_switches += -DLLVM_BUILD_TESTS=OFF
configure_switches += -DLLVM_INCLUDE_TESTS=OFF
configure_switches += -DLLVM_ENABLE_PIC=ON
configure_switches += -DLLVM_BINUTILS_INCDIR=$(TARGET_DEST_DIR)/usr/include
configure_switches += -DCLANG_RESOURCE_DIR='../../lib$(MULTILIB_SPARC32_SUFFIX)/clang/$(version)'
configure_switches += -DLLVM_TARGETS_TO_BUILD='host;AMDGPU;BPF'

configure_switches += -DCLANG_INCLUDE_TESTS=OFF

configure_switches += -DLIBUNWIND_ENABLE_ASSERTIONS=OFF
configure_switches += -DLIBUNWIND_ENABLE_SHARED=ON
configure_switches += -DLIBUNWIND_ENABLE_STATIC=OFF

#
# sparc32 do notprovide lock-free atomic, but LLVM uses std::sharedfuture
# GCC 7.x has fix for GCC_BUG_64735 but this caanot help in SPARC32 case.
#
# Currently we cannot build 32-compat LLVM.
#
configure_switches += -DCOMPILER_RT_USE_BUILTINS_LIBRARY=ON
configure_switches += -DCMAKE_CXX_STANDARD_LIBRARIES='-latomic'
configure_switches += -DLLVM_ENABLE_THREADS:BOOL=OFF

configure_switches += -DLLVM_TOOL_LIBUNWIND_BUILD:BOOL=$(ENABLE_LIBUNWIND)
configure_switches += -DLIBCXXABI_USE_LLVM_UNWINDER:BOOL=$(ENABLE_LIBUNWIND)

configure_switches += -DLLVM_TOOL_LIBCXX_BUILD:BOOL=$(ENABLE_LIBCXX)
configure_switches += -DLLVM_TOOL_LIBCXXABI_BUILD:BOOL=$(ENABLE_LIBCXXABI)
configure_switches += -DLLVM_TOOL_LLD_BUILD=$(ENABLE_LLDB)
configure_switches += -DLLVM_TOOL_OPENMP_BUILD:BOOL=$(ENABLE_OPENMP)
configure_switches += -DLLVM_TOOL_POLLY_BUILD:BOOL=$(ENABLE_POLLY)

PYTHON_VERSION = 3.7

configure_switches += -DPYTHON_EXECUTABLE=$(PYTHON3)
configure_switches += -DPYTHON_INCLUDE_DIR:PATH=$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)m
configure_switches += -DPYTHON_LIBRARY:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/libpython$(PYTHON_VERSION)m.so

configure_switches += -DFFI_INCLUDE_DIR=$(TARGET_DEST_DIR)/usr/include
configure_switches += -DFFI_LIBRARY_PATH=$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/libffi.so

configure_switches += -DLLVM_ENABLE_LIBEDIT=ON
configure_switches += -DLLVM_ENABLE_TERMINFO=ON
configure_switches += -DHAVE_TERMINFO_TINFO=ON

configure_switches += -DLIBOMPTARGET_DEP_LIBELF_INCLUDE_DIR:PATH=$(TARGET_DEST_DIR)/usr/include
configure_switches += -DLIBOMPTARGET_DEP_LIBELF_LIBRARIES:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/libelf.so

configure_switches += -DCURSES_CURSES_LIBRARY:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/libcursesw.so
configure_switches += -DCURSES_FORM_LIBRARY:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/libformw.so
configure_switches += -DCURSES_INCLUDE_PATH:PATH=$(TARGET_DEST_DIR)/usr/include
configure_switches += -DCURSES_NCURSES_LIBRARY:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/libncursesw.so
configure_switches += -DCURSES_PANEL_LIBRARY:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/libpanelw.so

configure_switches += -DDL_LIBRARY_PATH:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/libdl.so
configure_switches += -DICONV_LIBRARY_PATH:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/libc.so
configure_switches += -DLIBRT:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/librt.so

configure_switches += -DLLVM_BUILD_DOCS=OFF

configure_switches += -DCMAKE_CROSSCOMPILING=True

configure_switches += -DLLVM_DEFAULT_TARGET_TRIPLE=$(TARGET32)
configure_switches += -DCOMPILER_RT_DEFAULT_TARGET_TRIPLE=$(TARGET32)
configure_switches += -DLLVM_HOST_TRIPLE=$(TARGET32)

configure_switches += -DLLVM_TABLEGEN=$(CURDIR)/$(TARGET_BUILD_DIR)/build-machine/bin/llvm-tblgen
configure_switches += -DCLANG_TABLEGEN=$(CURDIR)/$(TARGET_BUILD_DIR)/build-machine/bin/clang-tblgen


configure_switches += -DLLVM_PARALLEL_COMPILE_JOBS=$(NUMPROCS)
configure_switches += -DLLVM_PARALLEL_LINK_JOBS=$(NUMPROCS)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	@echo "======= Expanding $(cfe_xz_archive) ======="
	@tar xJf $(cfe_xz_archive)         -C $(TARGET_BUILD_DIR)
	@echo "======= Expanding $(extra_tools_xz_archive) ======="
	@tar xJf $(extra_tools_xz_archive) -C $(TARGET_BUILD_DIR)/cfe-$(version).src/tools
	@( cd $(TARGET_BUILD_DIR)/cfe-$(version).src/tools ; \
	   mv clang-tools-extra-$(version).src extra ; \
	 )
	@echo "======= Expanding $(compiler_rt_xz_archive) ======="
	@tar xJf $(compiler_rt_xz_archive) -C $(TARGET_BUILD_DIR)
	@echo "======= Expanding $(lld_xz_archive) ======="
	@tar xJf $(lld_xz_archive)         -C $(TARGET_BUILD_DIR)
	@echo "======= Expanding $(polly_xz_archive) ======="
	@tar xJf $(polly_xz_archive)       -C $(TARGET_BUILD_DIR)
	@( cd $(SRC_DIR)/tools ; \
	   ln -sf ../../cfe-$(version).src   clang ; \
	   ln -sf ../../lld-$(version).src   lld   ; \
	   ln -sf ../../polly-$(version).src polly ; \
	 )
	@echo "======= Expanding $(openmp_xz_archive) ======="
	@tar xJf $(openmp_xz_archive)      -C $(TARGET_BUILD_DIR)
	@echo "======= Expanding $(libcxx_xz_archive) ======="
	@tar xJf $(libcxx_xz_archive)      -C $(TARGET_BUILD_DIR)
	@echo "======= Expanding $(libcxxabi_xz_archive) ======="
	@tar xJf $(libcxxabi_xz_archive)   -C $(TARGET_BUILD_DIR)
	@echo "======= Expanding $(libunwind_xz_archive) ======="
	@tar xJf $(libunwind_xz_archive)   -C $(TARGET_BUILD_DIR)
	@( cd $(SRC_DIR)/projects ; \
	   ln -sf ../../compiler-rt-$(version).src compiler-rt ; \
	   ln -sf ../../libcxx-$(version).src      libcxx      ; \
	   ln -sf ../../libcxxabi-$(version).src   libcxxabi   ; \
	   ln -sf ../../libunwind-$(version).src   libunwind   ; \
	   ln -sf ../../openmp-$(version).src      openmp      ; \
	 )
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(TARGET_BUILD_DIR)/build-machine
	@( cd $(TARGET_BUILD_DIR)/build-machine ; \
	   cmake -G Ninja -DCMAKE_BUILD_TYPE=Release \
	                  -DLLVM_LIBDIR_SUFFIX=$(MULTILIB_SPARC32_SUFFIX) \
	                  -DLLVM_INCLUDE_TESTS=OFF \
	                  -DLLVM_CCACHE_BUILD=ON \
	                  -DCCACHE_PROGRAM=$(CCACHE) \
	                  -DLLVM_CCACHE_DIR:STRING='$(CACHED_CC_OUTPUT)' \
	                  -DLLVM_CCACHE_PARAMS:STRING='CCACHE_CPP2=yes CCACHE_HASHDIR=yes CCACHE_BASEDIR=$(CCACHE_BASEDIR)' \
	                  ../llvm-$(version).src ; \
	   ninja  llvm-tblgen ; \
	   ninja clang-tblgen ; \
	   ninja  llvm-config ; \
	 )
	@mkdir -p $(build_dir)
	@( cd $(build_dir) ; \
	   $(BUILD_ENVIRONMENT) \
	     cmake -Wno-dev --trace-expand \
                   -G Ninja $(configure_switches) ../llvm-$(version).src 2> CMakeTrace.txt ; \
	 )
	@( cd $(build_dir) ; \
	   ninja all ; \
	 )
	exit 1
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LLVM_32_PKG)
	@cd $(build_dir) && $(env_sysroot) ninja install
	@( cd $(LLVM_32_PKG)/usr/bin ; \
	   ln -sf clang   $(TARGET32)-clang   ; \
	   ln -sf clang++ $(TARGET32)-clang++ ; \
	 )
	@( cd $(TARGET_BUILD_DIR)/build/bin ; \
	   cp -a clang-tblgen $(LLVM_32_PKG)/usr/bin ; \
	 )
	# ======= Move 32-Bit binaries into /usr/bin/32 directory =======
	@mkdir -p $(LLVM_32_PKG)/usr/bin/32
	@( cd $(LLVM_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	   find . -type l | xargs mv -t 32 ; \
	 )
	# ======= Install $(TARGET32)-llvm-config =======
	@( cd $(TARGET_BUILD_DIR)/build-machine/bin ; \
	   cp -a clang-tblgen $(LLVM_32_PKG)/usr/bin/$(TARGET32)-clang-tblgen ; \
	   cp -a llvm-tblgen  $(LLVM_32_PKG)/usr/bin/$(TARGET32)-llvm-tblgen  ; \
	   cp -a llvm-config  $(LLVM_32_PKG)/usr/bin/$(TARGET32)-llvm-config  ; \
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
	# ======= Remove symlink to libgomp, which is already provided by gcc =======
	@rm -f $(LLVM_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/libgomp.so
	# ======= Remove bundled python-six =======
	@rm -f $(LLVM_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python$(PYTHON_VERSION)/site-packages/six.py
	# ======= Install Python bindings =======
	@mkdir -p $(LLVM_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python2.7/site-packages
	@cp -a $(SRC_DIR)/tools/clang/bindings/python/clang $(LLVM_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python2.7/site-packages
	@PYTHONPATH=$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python2.7 $(PYTHON2)    -m compileall $(LLVM_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python2.7/site-packages/clang
	@PYTHONPATH=$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python2.7 $(PYTHON2) -O -m compileall $(LLVM_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python2.7/site-packages/clang
	# ======= Install Python3 bindings =======
	@mkdir -p $(LLVM_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python3.7/site-packages
	@cp -a $(SRC_DIR)/tools/clang/bindings/python/clang $(LLVM_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python3.7/site-packages
	@PYTHONPATH=$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python3.7 $(PYTHON3)    -m compileall $(LLVM_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python3.7/site-packages/clang
	@PYTHONPATH=$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python3.7 $(PYTHON3) -O -m compileall $(LLVM_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python3.7/site-packages/clang
	# ======= Remove build-dir from PollyConfig.cmake =======
	@( cd $(LLVM_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/cmake/polly ; \
	   sed -i 's,$(CURDIR)/$(build_dir),/usr,' PollyConfig.cmake ; \
	 )
	exit 1
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LLVM_32_PKG))
	# ======= Remove $(TARGET32)-llvm-config from target package =======
	@rm -f $(LLVM_32_PKG)/usr/bin/$(TARGET32)-clang-tblgen
	@rm -f $(LLVM_32_PKG)/usr/bin/$(TARGET32)-llvm-tblgen
	@rm -f $(LLVM_32_PKG)/usr/bin/$(TARGET32)-llvm-config
	# ======= Strip Binaries =======
	@( cd $(LLVM_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(LLVM_32_PKG_DESCRIPTION_FILE): $(LLVM_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
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
	@$(PSEUDO) sh -c "cd $(LLVM_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
