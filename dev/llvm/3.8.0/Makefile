
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

NOT_PARALLEL       = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/LLVM

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
endif
REQUIRES          += libs/libxml2/2.9.3

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

config_dir         = $(CURDIR)/config


PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LLVM_PKG_NAME                = llvm
LLVM_PKG_VERSION             = 3.8.0
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

TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

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

configure_switches += -DCMAKE_INSTALL_PREFIX=/usr
configure_switches += -DCMAKE_INSTALL_BINDIR=bin
configure_switches += -DCMAKE_INSTALL_LIBDIR=lib
configure_switches += -DCMAKE_INSTALL_LIBEXECDIR=libexec
configure_switches += -DCMAKE_INSTALL_DOCDIR='share/doc/$(doc_dir_name)'

configure_switches += -DLLVM_LIBDIR_SUFFIX=$(LIBSUFFIX)

configure_switches += -DCMAKE_BUILD_TYPE=Release
configure_switches += -DLLVM_BUILD_LLVM_DYLIB=ON
configure_switches += -DLLVM_LINK_LLVM_DYLIB=ON
configure_switches += -DLLVM_ENABLE_RTTI=ON
configure_switches += -DLLVM_ENABLE_FFI=ON
configure_switches += -DLLVM_ENABLE_ZLIB=ON
configure_switches += -DLLVM_ENABLE_ASSERTIONS=OFF
configure_switches += -DLLVM_ENABLE_PIC=ON
configure_switches += -DCLANG_RESOURCE_DIR='../lib$(LIBSUFFIX)/clang/$(version)'

configure_switches += -DFFI_INCLUDE_DIR=$(TARGET_DEST_DIR)/usr/include
configure_switches += -DFFI_LIBRARY_PATH=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libffi.so

configure_switches += -DLLVM_BUILD_DOCS=OFF

configure_switches += -DCMAKE_CROSSCOMPILING=True

configure_switches += -DLLVM_DEFAULT_TARGET_TRIPLE=$(TARGET)
configure_switches += -DCOMPILER_RT_DEFAULT_TARGET_TRIPLE=$(TARGET)
configure_switches += -DLLVM_HOST_TRIPLE=$(TARGET)

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
	   cmake -DCMAKE_BUILD_TYPE=Release ../llvm-$(version).src ; \
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
	@mkdir -p $(LLVM_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
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
	# ======= Install $(BUILD_MACHINE_ARCH)-llvm-config =======
	@( cd $(TARGET_BUILD_DIR)/build-machine/bin ; \
	   cp -a llvm-config $(LLVM_PKG)/usr/bin/$(BUILD_MACHINE_ARCH)-llvm-config ; \
	 )
	# ======= Install clang-static-analyzer =======
	@( cd $(LLVM_PKG)/usr/bin ; \
	   for i in ccc c++ ; do \
	     ln -sf ../libexec/$$i-analyzer $$i-analyzer ; \
	   done ; \
	 )
	# ======= Install Python bindings =======
	@mkdir -p $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/python2.7/site-packages
	@cp -a $(SRC_DIR)/tools/clang/bindings/python/clang $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/python2.7/site-packages
	@if [ -x /usr/bin/python2.7 ] ; then \
	   /usr/bin/python2.7 -m compileall $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/python2.7/site-packages/clang    ; \
	   /usr/bin/python2.7 -O -m compileall $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/python2.7/site-packages/clang ; \
	 fi
	# ======= Remove example libraries =======
	@rm -f $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/LLVMHello*
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
	@mkdir -p $(LLVM_PKG)/usr/doc/$(doc_dir_name)/clang
	@( cd $(SRC_DIR) ; \
	   cp -a CREDITS.TXT LICENSE.TXT \
	       $(LLVM_PKG)/usr/doc/$(doc_dir_name) ; \
	   cp -a tools/clang/LICENSE.TXT \
	       $(LLVM_PKG)/usr/doc/$(doc_dir_name)/clang ; \
	 )
	@mkdir -p $(LLVM_PKG)/usr/share/doc/$(doc_dir_name)/clang
	@( cd $(SRC_DIR) ; \
	   cp -a CODE_OWNERS.TXT CREDITS.TXT LICENSE.TXT README.txt \
	         $(LLVM_PKG)/usr/share/doc/$(doc_dir_name) ; \
	   cp -a tools/clang/CODE_OWNERS.TXT \
	         tools/clang/{INSTALL,LICENSE,NOTES,README}* \
	         $(LLVM_PKG)/usr/share/doc/$(doc_dir_name)/clang ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LLVM_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LLVM_PKG))
	# ======= Remove $(BUILD_MACHINE_ARCH)-llvm-config from target package =======
	@rm -f $(LLVM_PKG)/usr/bin/$(BUILD_MACHINE_ARCH)-llvm-config
	# ======= Strip Binaries =======
	@( cd $(LLVM_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LLVM_PKG_DESCRIPTION_FILE): $(LLVM_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

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
	@$(FAKEROOT) sh -c "cd $(LLVM_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
