
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/LLVM

REQUIRES           = dev/llvm/3.7.1
REQUIRES          += libs/libxml2/2.9.3-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 3.7.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/d/LLVM/llvm/llvm-$(version).src.tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/llvm-$(version).src
src_dir_name       = llvm-$(version).src
doc_dir_name       = llvm-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

cfe_xz_archive     = $(SRC_PACKAGE_PATH)/packages/d/LLVM/cfe/cfe-$(version).src.tar.xz

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
LLVM_32_PKG_VERSION             = 3.7.1
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


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-libffi
extra_configure_switches += --enable-zlib
extra_configure_switches += --enable-optimized
extra_configure_switches += --enable-shared
extra_configure_switches += --disable-assertions
extra_configure_switches += --enable-pic
extra_configure_switches += --enable-targets=all
extra_configure_switches += --with-clang-resource-dir="../../lib$(MULTILIB_X86_32_SUFFIX)/clang/$(version)"
extra_configure_switches += --with-bug-report-url="$(BUG_URL)"
#
# Do not strip during installation:
#
extra_configure_switches += --enable-keep-symbols

environment  = BUILD_AR=ar
environment += BUILD_AS=as
environment += BUILD_RANLIB=ranlib
environment += BUILD_LD=gcc
environment += BUILD_CC=gcc
environment += BUILD_CXX=g++
environment += BUILD_CFLAGS=-I/usr/include
environment += BUILD_CXXFLAGS=-I/usr/include
environment += BUILD_LDFLAGS=-L/usr/lib$(BUILD_MULTILIB_SUFFIX)
environment += RANLIB=ranlib


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	@echo "Expanding $(cfe_xz_archive)"
	@tar xJf $(cfe_xz_archive) -C $(TARGET_BUILD_DIR)
	@( cd $(SRC_DIR)/tools ; \
	   ln -sf ../../cfe-$(version).src clang ; \
	 )
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	$(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure $(environment) \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	# ======= Fix hardcoded libdir =======
	@( cd $(build_dir) ; \
	   sed -i "s|\$(PROJ_prefix)/lib|\$(PROJ_prefix)/lib$(MULTILIB_X86_32_SUFFIX)|" \
	     Makefile.config ; \
	 )
	@( cd $(SRC_DIR) ; \
	   sed -i "s|\$(PROJ_prefix)/lib|\$(PROJ_prefix)/lib$(MULTILIB_X86_32_SUFFIX)|" \
	     tools/clang/lib/Headers/Makefile ; \
	   sed -i "s|\"lib\"|\"lib$(MULTILIB_X86_32_SUFFIX)\"|" \
	     tools/clang/lib/Frontend/CompilerInvocation.cpp ; \
	   sed -i "s|\"lib\"|\"lib$(MULTILIB_X86_32_SUFFIX)\"|" \
	     tools/clang/lib/Driver/Tools.cpp ; \
	   sed -i "s|ActivePrefix = CurrentExecPrefix|ActivePrefix = sys::path::parent_path\(CurrentExecPrefix\).str\(\)|g" \
	     tools/llvm-config/llvm-config.cpp ; \
	   sed -i "s|ActiveBinDir = ActivePrefix + \"/bin\"|ActiveBinDir = ActivePrefix + \"/bin/32\"|g" \
	     tools/llvm-config/llvm-config.cpp ; \
	   sed -i "s|ActiveLibDir = ActivePrefix + \"/lib\"|ActiveLibDir = ActivePrefix + \"/lib$(MULTILIB_X86_32_SUFFIX)\"|g" \
	     tools/llvm-config/llvm-config.cpp ; \
	 )
	# ======= Fix libxml2 includes =======
	@( cd $(build_dir) ; \
	   sed -i "s,^\(LIBXML2_INC .*:=\).*,\1 -I$(TARGET_DEST_DIR)/usr/include/libxml2," Makefile.config ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
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
	# ======= Install clang-static-analyzer =======
	@mkdir -p $(LLVM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/clang-analyzer
	@( cd $(SRC_DIR) ; \
	   cp -r tools/clang/tools/scan-{build,view} \
	         $(LLVM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/clang-analyzer ; \
	 )
	@( cd $(LLVM_32_PKG)/usr/bin/32 ; \
	   for i in scan-{build,view} ; do \
	     ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/clang-analyzer/$$i/$$i $$i ; \
	   done ; \
	   for i in ccc c++ ; do \
	     ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/clang-analyzer/scan-build/$$i-analyzer $$i-analyzer ; \
	   done ; \
	   sed -i "s|\$RealBin/bin|/usr/bin/32|" \
	     $(LLVM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/clang-analyzer/scan-build/scan-build ; \
	   sed -i "s|\$RealBin/sorttable.js|/usr/lib$(MULTILIB_X86_32_SUFFIX)/clang-analyzer/scan-build/sorttable.js|" \
	     $(LLVM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/clang-analyzer/scan-build/scan-build ; \
	   sed -i "s|\$RealBin/scanview.css|/usr/lib$(MULTILIB_X86_32_SUFFIX)/clang-analyzer/scan-build/scanview.css|" \
	     $(LLVM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/clang-analyzer/scan-build/scan-build ; \
	 )
	# ======= Remove example libraries =======
	@rm -f $(LLVM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/LLVMHello*
	@( cd $(LLVM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; chmod 0644 *.a )
	# ======= Save config.h and llvm-config.h =======
	@for header in config llvm-config ; do \
	  cp -a $(LLVM_32_PKG)/usr/include/llvm/Config/$$header.h $(TARGET_BUILD_DIR) ; \
	 done
	@rm -rf $(LLVM_32_PKG)/usr/docs
	@rm -rf $(LLVM_32_PKG)/usr/include
	@rm -rf $(LLVM_32_PKG)/usr/share
	# ======= Restore config-32.h and llvm-config-32.h =======
	@mkdir -p $(LLVM_32_PKG)/usr/include/llvm/Config
	@for header in config llvm-config ; do \
	  cp -a $(TARGET_BUILD_DIR)/$$header.h $(LLVM_32_PKG)/usr/include/llvm/Config/$$header-32.h ; \
	 done
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LLVM_32_PKG))
	# ======= Remove llvm-config-host from target package =======
	@rm -f $(LLVM_32_PKG)/usr/bin/32/llvm-config-host
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
