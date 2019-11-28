
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP2E)
COMPONENT_TARGETS += $(HARDWARE_NANOPI_NEO)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PL2)
COMPONENT_TARGETS += $(HARDWARE_WECHIP_TX6)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_RK3328_CC)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_EDGE)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OKMX6DL_C)
COMPONENT_TARGETS += $(HARDWARE_OKMX6Q_C)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BAIKAL_T1)
COMPONENT_TARGETS += $(HARDWARE_MBC4_PC)
COMPONENT_TARGETS += $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_S824L_LSB)
COMPONENT_TARGETS += $(HARDWARE_VESNIN_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2_LSB)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

NOT_PARALLEL       = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/LLVM

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/6.5.0
endif
REQUIRES          += libs/libffi/3.2.1
REQUIRES          += libs/libxml2/2.9.9
REQUIRES          += libs/libedit/20191025-3.1
REQUIRES          += libs/ncurses/6.1
REQUIRES          += dev/python2/2.7.16
REQUIRES          += dev/python3/3.7.4

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

lldb_xz_archive        = $(SRC_PACKAGE_PATH)/packages/d/LLVM/lldb/lldb-$(version).src.tar.xz
lld_xz_archive         = $(SRC_PACKAGE_PATH)/packages/d/LLVM/lld/lld-$(version).src.tar.xz
polly_xz_archive       = $(SRC_PACKAGE_PATH)/packages/d/LLVM/polly/polly-$(version).src.tar.xz

openmp_xz_archive      = $(SRC_PACKAGE_PATH)/packages/d/LLVM/openmp/openmp-$(version).src.tar.xz
libcxx_xz_archive      = $(SRC_PACKAGE_PATH)/packages/d/LLVM/libcxx/libcxx-$(version).src.tar.xz
libcxxabi_xz_archive   = $(SRC_PACKAGE_PATH)/packages/d/LLVM/libcxxabi/libcxxabi-$(version).src.tar.xz
libunwind_xz_archive   = $(SRC_PACKAGE_PATH)/packages/d/LLVM/libunwind/libunwind-$(version).src.tar.xz


config_dir         = $(CURDIR)/config

PATCHES = PATCHES

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_P5600_GLIBC))
OPT_PATCHES = PATCHES.p5600
endif

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LLVM_PKG_NAME                = llvm
LLVM_PKG_VERSION             = 9.0.0
LLVM_PKG_ARCH                = $(TOOLCHAIN)
LLVM_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LLVM_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LLVM_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
LLVM_PKG_SHORT_DESCRIPTION   = LLVM compiler toolkit
LLVM_PKG_URL                 = $(BUG_URL)
LLVM_PKG_LICENSE             = custom
LLVM_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LLVM_PKG_NAME)-pkg-description
LLVM_PKG_DESCRIPTION_FILE_IN = $(LLVM_PKG_NAME)-pkg-description.in
LLVM_PKG_INSTALL_SCRIPT      = $(LLVM_PKG_NAME)-pkg-install.sh

LLVM_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LLVM_PKG_NAME)-package

pkg_basename     = $(LLVM_PKG_NAME)-$(LLVM_PKG_VERSION)-$(LLVM_PKG_ARCH)-$(LLVM_PKG_DISTRO_NAME)-$(LLVM_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(LLVM_PKG)


LLVM_JOBS = -j$(NUMPROCS)


ENABLE_LIBCXX    = ON
ENABLE_LIBCXXABI = ON
ENABLE_LIBUNWIND = OFF
ENABLE_LLDB      = ON
ENABLE_LLD       = ON
ENABLE_OPENMP    = ON
ENABLE_POLLY     = ON


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

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

configure_switches += -DCMAKE_C_FLAGS:STRING='--sysroot=$(TARGET_DEST_DIR) $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS)'
configure_switches += -DCMAKE_CXX_FLAGS:STRING='--sysroot=$(TARGET_DEST_DIR) $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS)'

configure_switches += -DCMAKE_EXE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -Wl,-rpath,$(TARGET_BIN_RPATH) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)'
configure_switches += -DCMAKE_MODULE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)'
configure_switches += -DCMAKE_SHARED_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)'

configure_switches += -DCMAKE_SKIP_INSTALL_RPATH=NO
configure_switches += -DCMAKE_SKIP_RPATH=YES


ifeq ($(TOOLCHAIN),$(TOOLCHAIN_JZ47XX_GLIBC))
configure_switches += -DCMAKE_C_FLAGS_RELEASE='-O2 -DNDEBUG'
configure_switches += -DCMAKE_CXX_FLAGS_RELEASE='-O2 -DNDEBUG'
configure_switches += -DCMAKE_ASM_FLAGS_RELEASE='-O2 -DNDEBUG'
endif

configure_switches += -DLLVM_CCACHE_BUILD=ON
configure_switches += -DCCACHE_PROGRAM=$(CCACHE)
configure_switches += -DLLVM_CCACHE_DIR:STRING='$(CACHED_CC_OUTPUT)'
configure_switches += -DLLVM_CCACHE_PARAMS:STRING='CCACHE_CPP2=yes CCACHE_HASHDIR=yes CCACHE_BASEDIR=$(CCACHE_BASEDIR)'

configure_switches += -DCMAKE_SYSTEM_NAME:STRING='Linux'

configure_switches += -DCMAKE_INSTALL_PREFIX=/usr
configure_switches += -DCMAKE_INSTALL_BINDIR=bin
configure_switches += -DCMAKE_INSTALL_LIBDIR=lib$(LIBSUFFIX)
configure_switches += -DCMAKE_INSTALL_LIBEXECDIR=libexec
configure_switches += -DCMAKE_INSTALL_DOCDIR='share/doc/$(doc_dir_name)'

configure_switches += -DLLVM_LIBDIR_SUFFIX=$(LIBSUFFIX)

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
configure_switches += -DCLANG_RESOURCE_DIR='../lib$(LIBSUFFIX)/clang/$(version)'
configure_switches += -DLLVM_TARGETS_TO_BUILD='host;AMDGPU;BPF'
#
# Documentation (https://llvm.org/docs/CMake.html) say that the
# variable LLVM_TARGET_ARCH  should be set when cross compiling
# but on practice it is not needed.
# Available names are defined in llvm/cmake/config-ix.cmake:397
#
# configure_switches += -DLLVM_TARGET_ARCH='x86_64'
#

configure_switches += -DLLDB_INCLUDE_TESTS=OFF
configure_switches += -DCLANG_INCLUDE_TESTS=OFF

#
# libunwind:
#
# By default the variable LIBCXXABI_USE_LLVM_UNWINDER is OFF
#
#   LIBCXXABI_USE_LLVM_UNWINDER:BOOL=OFF
#
# LLVM's libunwind is created but not used by libc++abi.so
# But ARM targets require the _URC_FATAL_PHASE1_ERROR enum
# defined in unwind.h from LLVM's linunwind.
#
# We need to deside do we need the LLVM's libunwind in system
# or not. Also we remember that GCC variant libunwind
# doesn't work on AArch64 targets (at least when we used GCC-5.4).
#
# To disable build LLVM's libunwind set:
#
# configure_switches += -DLLVM_TOOL_LIBUNWIND_BUILD:BOOL=OFF
# configure_switches += -DLIBCXXABI_USE_LLVM_UNWINDER:BOOL=OFF
#
# but keep LLVM's libunwind sources in projects/libunwind for ARM.
#
configure_switches += -DLIBUNWIND_ENABLE_ASSERTIONS=OFF
configure_switches += -DLIBUNWIND_ENABLE_SHARED=ON
configure_switches += -DLIBUNWIND_ENABLE_STATIC=OFF



ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_JZ47XX_GLIBC) \
                             $(TOOLCHAIN_P5600_GLIBC)),)
ENABLE_OPENMP   = OFF
endif

ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC)),)
configure_switches += -DCOMPILER_RT_USE_BUILTINS_LIBRARY=ON
configure_switches += -DCMAKE_CXX_STANDARD_LIBRARIES='-ldl -lpthread -lrt -latomic'

ENABLE_OPENMP   = OFF
ENABLE_LLDB     = OFF
endif

configure_switches += -DLLVM_TOOL_LIBUNWIND_BUILD:BOOL=$(ENABLE_LIBUNWIND)
configure_switches += -DLIBCXXABI_USE_LLVM_UNWINDER:BOOL=$(ENABLE_LIBUNWIND)

configure_switches += -DLLVM_TOOL_LIBCXX_BUILD:BOOL=$(ENABLE_LIBCXX)
configure_switches += -DLLVM_TOOL_LIBCXXABI_BUILD:BOOL=$(ENABLE_LIBCXXABI)
configure_switches += -DLLVM_TOOL_LLDB_BUILD=$(ENABLE_LLDB)
configure_switches += -DLLVM_TOOL_LLD_BUILD=$(ENABLE_LLDB)
configure_switches += -DLLVM_TOOL_OPENMP_BUILD:BOOL=$(ENABLE_OPENMP)
configure_switches += -DLLVM_TOOL_POLLY_BUILD:BOOL=$(ENABLE_POLLY)


PYTHON_VERSION = 3.7

configure_switches += -DPYTHON_EXECUTABLE=$(PYTHON3)
configure_switches += -DPYTHON_INCLUDE_DIR:PATH=$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)m
configure_switches += -DPYTHON_LIBRARY:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libpython$(PYTHON_VERSION)m.so

configure_switches += -DFFI_INCLUDE_DIR=$(TARGET_DEST_DIR)/usr/include
configure_switches += -DFFI_LIBRARY_PATH=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libffi.so

configure_switches += -DLLVM_ENABLE_LIBEDIT=ON
configure_switches += -DLLVM_ENABLE_TERMINFO=ON
configure_switches += -DHAVE_TERMINFO_TINFO=ON

configure_switches += -DLIBOMPTARGET_DEP_LIBELF_INCLUDE_DIR:PATH=$(TARGET_DEST_DIR)/usr/include
configure_switches += -DLIBOMPTARGET_DEP_LIBELF_LIBRARIES:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libelf.so

configure_switches += -DCURSES_CURSES_LIBRARY:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libcursesw.so
configure_switches += -DCURSES_FORM_LIBRARY:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libformw.so
configure_switches += -DCURSES_INCLUDE_PATH:PATH=$(TARGET_DEST_DIR)/usr/include
configure_switches += -DCURSES_NCURSES_LIBRARY:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libncursesw.so
configure_switches += -DCURSES_PANEL_LIBRARY:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libpanelw.so

configure_switches += -DDL_LIBRARY_PATH:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libdl.so
configure_switches += -DICONV_LIBRARY_PATH:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libc.so
configure_switches += -DLIBRT:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/librt.so

configure_switches += -DLLVM_BUILD_DOCS=OFF

configure_switches += -DCMAKE_CROSSCOMPILING=True

configure_switches += -DLLVM_DEFAULT_TARGET_TRIPLE=$(TARGET)
configure_switches += -DCOMPILER_RT_DEFAULT_TARGET_TRIPLE=$(TARGET)
configure_switches += -DLLVM_HOST_TRIPLE=$(TARGET)

configure_switches += -DLLVM_TABLEGEN=$(CURDIR)/$(TARGET_BUILD_DIR)/build-machine/bin/llvm-tblgen
configure_switches += -DCLANG_TABLEGEN=$(CURDIR)/$(TARGET_BUILD_DIR)/build-machine/bin/clang-tblgen
configure_switches += -DLLDB_TABLEGEN=$(CURDIR)/$(TARGET_BUILD_DIR)/build-machine/bin/lldb-tblgen


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
	@echo "======= Expanding $(lldb_xz_archive) ======="
	@tar xJf $(lldb_xz_archive)        -C $(TARGET_BUILD_DIR)
	@echo "======= Expanding $(lld_xz_archive) ======="
	@tar xJf $(lld_xz_archive)         -C $(TARGET_BUILD_DIR)
	@echo "======= Expanding $(polly_xz_archive) ======="
	@tar xJf $(polly_xz_archive)       -C $(TARGET_BUILD_DIR)
	@( cd $(SRC_DIR)/tools ; \
	   ln -sf ../../cfe-$(version).src   clang ; \
	   ln -sf ../../lldb-$(version).src  lldb  ; \
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
ifneq ($(OPT_PATCHES),)
	$(call apply-opt-patches, $(SRC_DIR))
endif
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(TARGET_BUILD_DIR)/build-machine
	@( cd $(TARGET_BUILD_DIR)/build-machine ; \
	   cmake -G Ninja -DCMAKE_BUILD_TYPE=Release \
	                  -DLLVM_LIBDIR_SUFFIX=$(LIBSUFFIX) \
	                  -DLLVM_INCLUDE_TESTS=OFF \
	                  -DLLVM_CCACHE_BUILD=ON \
	                  -DCCACHE_PROGRAM=$(CCACHE) \
	                  -DLLVM_CCACHE_DIR:STRING='$(CACHED_CC_OUTPUT)' \
	                  -DLLVM_CCACHE_PARAMS:STRING='CCACHE_CPP2=yes CCACHE_HASHDIR=yes CCACHE_BASEDIR=$(CCACHE_BASEDIR)' \
	                  ../llvm-$(version).src ; \
	   ninja  llvm-tblgen ; \
	   ninja clang-tblgen ; \
	   ninja  lldb-tblgen ; \
	   ninja  llvm-config ; \
	 )
	@mkdir -p $(build_dir)
	@( cd $(build_dir) ; \
	   $(BUILD_ENVIRONMENT) \
	     cmake -Wno-dev --trace-expand \
                   -G Ninja $(configure_switches) ../llvm-$(version).src 2> CMakeTrace.txt ; \
	 )
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC) \
                             $(TOOLCHAIN_R1000_GLIBC)  \
                             $(TOOLCHAIN_POWER8_GLIBC) \
                             $(TOOLCHAIN_POWER9_GLIBC)),)
	# ===========================================================================
	# ======= Edit LINK_FLAGS generated by compiler-rt for 32-bit runtimes ======
	# ===========================================================================
	@( cd $(build_dir) ; \
	   for ln in `grep -n '^[ t]*LINK_FLAGS.*=.*-m32' build.ninja | cut -f1 -d':' | tr '\n' ' '` ; do \
	     line= repl= match= ; \
	     line=`sed "$$ln!d" build.ninja` ; \
	     match=`echo "$$line" | grep "$(TARGET_DEST_DIR)/lib"` ; \
	     if [ -z "$$match" ] ; then \
	       repl=`echo "$$line" | sed "s|--sysroot=$(TARGET_DEST_DIR)|--sysroot=$(TARGET_DEST_DIR) -L$(TARGET_DEST_DIR)/lib32 -L$(TARGET_DEST_DIR)/usr/lib32|g"` ; \
	     else \
	       repl=`echo "$$line" | sed "s|-L$(TARGET_DEST_DIR)/lib|-L$(TARGET_DEST_DIR)/lib32|g"` ; \
	       repl=`echo "$$repl" | sed "s|-L$(TARGET_DEST_DIR)/usr/lib|-L$(TARGET_DEST_DIR)/usr/lib32|g"` ; \
	     fi ; \
	     repl=`echo "$$repl" | sed "s|/lib:/usr/lib:/usr/lib/../lib|/lib32:/usr/lib32:/usr/lib/../lib32|g"` ; \
	     sed -i "$${ln}s|.*|$${repl}|" build.ninja ; \
	   done ; \
	   for ln in `grep -n '^[ t]*LINK_FLAGS.*=.*-m64' build.ninja | cut -f1 -d':' | tr '\n' ' '` ; do \
	     line= repl= match= ; \
	     line=`sed "$$ln!d" build.ninja` ; \
	     match=`echo "$$line" | grep "$(TARGET_DEST_DIR)/lib"` ; \
	     if [ -z "$$match" ] ; then \
	       repl=`echo "$$line" | sed "s|--sysroot=$(TARGET_DEST_DIR)|--sysroot=$(TARGET_DEST_DIR) -L$(TARGET_DEST_DIR)/lib -L$(TARGET_DEST_DIR)/usr/lib|g"` ; \
	     else \
	       repl=$$line ; \
	     fi ; \
	     sed -i "$${ln}s|.*|$${repl}|" build.ninja ; \
	   done ; \
	 )
endif
	@( cd $(build_dir) ; \
	   ninja all ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LLVM_PKG)
	@cd $(build_dir) && $(env_sysroot) ninja install
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC) \
                             $(TOOLCHAIN_R1000_GLIBC)  \
                             $(TOOLCHAIN_POWER8_GLIBC) \
                             $(TOOLCHAIN_POWER9_GLIBC)),)
	@for header in config ; do \
	   mv $(LLVM_PKG)/usr/include/clang/Config/$$header{,-64}.h ; \
	   cp -a $(config_dir)/$$header.h $(LLVM_PKG)/usr/include/clang/Config/$$header.h ; \
	 done
	@for header in llvm-config ; do \
	   mv $(LLVM_PKG)/usr/include/llvm/Config/$$header{,-64}.h ; \
	   cp -a $(config_dir)/$$header.h $(LLVM_PKG)/usr/include/llvm/Config/$$header.h ; \
	 done
endif
	@( cd $(LLVM_PKG)/usr/bin ; \
	   ln -sf clang   $(TARGET)-clang   ; \
	   ln -sf clang++ $(TARGET)-clang++ ; \
	 )
	@( cd $(TARGET_BUILD_DIR)/build/bin ; \
	   cp -a clang-tblgen $(LLVM_PKG)/usr/bin ; \
	 )
	# ======= Install $(TARGET)-llvm-config =======
	@( cd $(TARGET_BUILD_DIR)/build-machine/bin ; \
	   cp -a clang-tblgen $(LLVM_PKG)/usr/bin/$(TARGET)-clang-tblgen ; \
	   cp -a llvm-tblgen  $(LLVM_PKG)/usr/bin/$(TARGET)-llvm-tblgen  ; \
	   cp -a lldb-tblgen  $(LLVM_PKG)/usr/bin/$(TARGET)-lldb-tblgen  ; \
	   cp -a llvm-config  $(LLVM_PKG)/usr/bin/$(TARGET)-llvm-config  ; \
	 )
	# ======= Install clang-static-analyzer =======
	@( cd $(LLVM_PKG)/usr/bin ; \
	   for i in ccc c++ ; do \
	     ln -sf ../libexec/$$i-analyzer $$i-analyzer ; \
	   done ; \
	 )
	# ======= Remove symlink to libgomp, which is already provided by gcc =======
	@rm -f $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/libgomp.so
	# ======= Remove bundled python-six =======
	@rm -f $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages/six.py
	# ======= Install Python bindings =======
	@mkdir -p $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/python2.7/site-packages
	@cp -a $(SRC_DIR)/tools/clang/bindings/python/clang $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/python2.7/site-packages
	@$(PYTHON2)    -m compileall $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/python2.7/site-packages/clang
	@$(PYTHON2) -O -m compileall $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/python2.7/site-packages/clang
	# ======= Install Python3 bindings =======
	@mkdir -p $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/python3.7/site-packages
	@cp -a $(SRC_DIR)/tools/clang/bindings/python/clang $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/python3.7/site-packages
	@$(PYTHON3)    -m compileall $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/python3.7/site-packages/clang
	@$(PYTHON3) -O -m compileall $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/python3.7/site-packages/clang
	# ======= Compile bindings by Python2 =======
	@$(PYTHON2)    -m compileall $(LLVM_PKG)/usr/share/clang
	@$(PYTHON2) -O -m compileall $(LLVM_PKG)/usr/share/clang
	@$(PYTHON2)    -m compileall $(LLVM_PKG)/usr/share/opt-viewer
	@$(PYTHON2) -O -m compileall $(LLVM_PKG)/usr/share/opt-viewer
	@$(PYTHON2)    -m compileall $(LLVM_PKG)/usr/share/scan-view
	@$(PYTHON2) -O -m compileall $(LLVM_PKG)/usr/share/scan-view
	# ======= Install Documentation =======
	@( cd $(LLVM_PKG)/usr/share/man/man1 ; \
	   chmod 644 *.1 ; \
	 )
	@if [ -d $(LLVM_PKG)/usr/share/man ] ; then \
	  ( cd $(LLVM_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.?  ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(LLVM_PKG)/usr/doc/$(doc_dir_name)/{clang,clang-tools-extra,compiler-rt}
	@( cd $(SRC_DIR) ; \
	   cp -a {CODE_OWNERS,CREDITS,LICENSE}* \
	         $(LLVM_PKG)/usr/doc/$(doc_dir_name) ; \
	   cp -a tools/clang/{CODE_OWNERS,LICENSE}* \
	         $(LLVM_PKG)/usr/doc/$(doc_dir_name)/clang ; \
	   cp -a tools/clang/tools/extra/{CODE_OWNERS,LICENSE}* \
	         $(LLVM_PKG)/usr/doc/$(doc_dir_name)/clang-tools-extra ; \
	   cp -a projects/compiler-rt/{CODE_OWNERS,CREDITS,LICENSE}* \
	         $(LLVM_PKG)/usr/doc/$(doc_dir_name)/compiler-rt ; \
	 )
ifeq ($(ENABLE_LLDB),ON)
	@mkdir -p $(LLVM_PKG)/usr/doc/$(doc_dir_name)/lld
	@( cd $(SRC_DIR) ; cp -a tools/lld/{CODE_OWNERS,LICENSE}* \
	                         $(LLVM_PKG)/usr/doc/$(doc_dir_name)/lld ; \
	 )
endif
ifeq ($(ENABLE_LLDB),ON)
	@mkdir -p $(LLVM_PKG)/usr/doc/$(doc_dir_name)/lldb
	@( cd $(SRC_DIR) ; cp -a tools/lldb/{CODE_OWNERS,LICENSE}* \
	                         $(LLVM_PKG)/usr/doc/$(doc_dir_name)/lldb ; \
	 )
endif
ifeq ($(ENABLE_OPENMP),ON)
	@mkdir -p $(LLVM_PKG)/usr/doc/$(doc_dir_name)/openmp
	@( cd $(SRC_DIR) ; cp -a projects/openmp/{CREDITS,LICENSE}* \
	                         $(LLVM_PKG)/usr/doc/$(doc_dir_name)/openmp ; \
	 )
endif
ifeq ($(ENABLE_POLLY),ON)
	@mkdir -p $(LLVM_PKG)/usr/doc/$(doc_dir_name)/polly
	@( cd $(SRC_DIR) ; cp -a tools/polly/{CREDITS,LICENSE}* \
	                   $(LLVM_PKG)/usr/doc/$(doc_dir_name)/polly ; \
	 )
endif
	@mkdir -p $(LLVM_PKG)/usr/share/doc/$(doc_dir_name)/{clang,clang-tools-extra,compiler-rt}
	@( cd $(SRC_DIR) ; \
	   cp -a {CODE_OWNERS,CREDITS,LICENSE,README}* \
	         $(LLVM_PKG)/usr/share/doc/$(doc_dir_name) ; \
	   cp -a tools/clang/{CODE_OWNERS,INSTALL,LICENSE,NOTES,README}* \
	         $(LLVM_PKG)/usr/share/doc/$(doc_dir_name)/clang ; \
	   cp -a tools/clang/tools/extra/{CODE_OWNERS,LICENSE,README}* \
	         $(LLVM_PKG)/usr/share/doc/$(doc_dir_name)/clang-tools-extra ; \
	   cp -a projects/compiler-rt/{CODE_OWNERS,CREDITS,LICENSE,README}* \
	         $(LLVM_PKG)/usr/share/doc/$(doc_dir_name)/compiler-rt ; \
	 )
ifeq ($(ENABLE_LLDB),ON)
	@mkdir -p $(LLVM_PKG)/usr/share/doc/$(doc_dir_name)/lld
	@( cd $(SRC_DIR) ; \
	   cp -a tools/lld/{CODE_OWNERS,LICENSE,README}* \
	         $(LLVM_PKG)/usr/share/doc/$(doc_dir_name)/lld ; \
	 )
endif
ifeq ($(ENABLE_LLDB),ON)
	@mkdir -p $(LLVM_PKG)/usr/share/doc/$(doc_dir_name)/lldb
	@( cd $(SRC_DIR) ; \
	   cp -a tools/lldb/{CODE_OWNERS,INSTALL,LICENSE}* \
	         $(LLVM_PKG)/usr/share/doc/$(doc_dir_name)/lldb ; \
	 )
endif
ifeq ($(ENABLE_OPENMP),ON)
	@mkdir -p $(LLVM_PKG)/usr/share/doc/$(doc_dir_name)/openmp
	@( cd $(SRC_DIR) ; \
	   cp -a projects/openmp/{CREDITS,LICENSE,README}* \
	         $(LLVM_PKG)/usr/share/doc/$(doc_dir_name)/openmp ; \
	 )
endif
ifeq ($(ENABLE_POLLY),ON)
	@mkdir -p $(LLVM_PKG)/usr/share/doc/$(doc_dir_name)/polly
	@( cd $(SRC_DIR) ; cp -a tools/polly/{CREDITS,LICENSE,README}* \
	                         $(LLVM_PKG)/usr/share/doc/$(doc_dir_name)/polly ; \
	 )
endif
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LLVM_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Remove build-dir from PollyConfig.cmake =======
	@( cd $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/cmake/polly ; \
	   sed -i 's,$(CURDIR)/$(build_dir),/usr,' PollyConfig.cmake ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LLVM_PKG))
	# ======= Remove $(TARGET)-llvm-config from target package =======
	@rm -f $(LLVM_PKG)/usr/bin/$(TARGET)-clang-tblgen
	@rm -f $(LLVM_PKG)/usr/bin/$(TARGET)-llvm-tblgen
	@rm -f $(LLVM_PKG)/usr/bin/$(TARGET)-lldb-tblgen
	@rm -f $(LLVM_PKG)/usr/bin/$(TARGET)-llvm-config
	# ======= Strip Binaries =======
	@( cd $(LLVM_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(LLVM_PKG_DESCRIPTION_FILE): $(LLVM_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LLVM_PKG_DESCRIPTION_FILE) $(LLVM_PKG_INSTALL_SCRIPT)
	@cp $(LLVM_PKG_DESCRIPTION_FILE) $(LLVM_PKG)/.DESCRIPTION
	@cp $(LLVM_PKG_INSTALL_SCRIPT) $(LLVM_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LLVM_PKG)/.REQUIRES
	@echo "pkgname=$(LLVM_PKG_NAME)"                            >  $(LLVM_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LLVM_PKG_VERSION)"                          >> $(LLVM_PKG)/.PKGINFO ; \
	 echo "arch=$(LLVM_PKG_ARCH)"                               >> $(LLVM_PKG)/.PKGINFO ; \
	 echo "distroname=$(LLVM_PKG_DISTRO_NAME)"                  >> $(LLVM_PKG)/.PKGINFO ; \
	 echo "distrover=$(LLVM_PKG_DISTRO_VERSION)"                >> $(LLVM_PKG)/.PKGINFO ; \
	 echo "group=$(LLVM_PKG_GROUP)"                             >> $(LLVM_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LLVM_PKG_SHORT_DESCRIPTION)\"" >> $(LLVM_PKG)/.PKGINFO ; \
	 echo "url=$(LLVM_PKG_URL)"                                 >> $(LLVM_PKG)/.PKGINFO ; \
	 echo "license=$(LLVM_PKG_LICENSE)"                         >> $(LLVM_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LLVM_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
