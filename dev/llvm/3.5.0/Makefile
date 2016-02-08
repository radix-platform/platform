
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


SOURCE_REQUIRES    = sources/packages/d/LLVM

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/4.9.2
endif
REQUIRES          += libs/libxml2/2.9.1

# ======= __END_OF_REQUIRES__ =======


version            = 3.5.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/d/LLVM/llvm/llvm-$(version).src.tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/llvm-$(version).src
src_dir_name       = llvm-$(version).src
doc_dir_name       = llvm-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

cfe_xz_archive     = $(SRC_PACKAGE_PATH)/packages/d/LLVM/cfe/cfe-$(version).src.tar.xz

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
LLVM_PKG_VERSION             = 3.5.0
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


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
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
extra_configure_switches += --with-clang-resource-dir="../lib$(LIBSUFFIX)/clang/$(version)"
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
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	# ======= Fix hardcoded libdir =======
	@( cd $(build_dir) ; \
	   sed -i "s|\$(PROJ_prefix)/lib|\$(PROJ_prefix)/lib$(LIBSUFFIX)|" \
	     Makefile.config ; \
	 )
	@( cd $(SRC_DIR) ; \
	   sed -i "s|\$(PROJ_prefix)/lib|\$(PROJ_prefix)/lib$(LIBSUFFIX)|" \
	     tools/clang/lib/Headers/Makefile ; \
	   sed -i "s|\"lib\"|\"lib$(LIBSUFFIX)\"|" \
	     tools/clang/lib/Frontend/CompilerInvocation.cpp ; \
	   sed -i "s|\"lib\"|\"lib$(LIBSUFFIX)\"|" \
	     tools/clang/lib/Driver/Tools.cpp ; \
	   sed -i "s|ActiveLibDir = ActivePrefix + \"/lib\"|ActiveLibDir = ActivePrefix + \"/lib$(LIBSUFFIX)\"|g" \
	     tools/llvm-config/llvm-config.cpp ; \
	 )
	# ======= Fix libxml2 includes =======
	@( cd $(build_dir) ; \
	   sed -i "s,^\(LIBXML2_INC .*:=\).*,\1 -I$(TARGET_DEST_DIR)/usr/include/libxml2," Makefile.config ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LLVM_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
	@for header in config llvm-config ; do \
	   mv $(LLVM_PKG)/usr/include/llvm/Config/$$header{,-64}.h ; \
	   cp -a $(config_dir)/$$header.h $(LLVM_PKG)/usr/include/llvm/Config/$$header.h ; \
	 done
endif
	@( cd $(LLVM_PKG)/usr/bin ; \
	   ln -sf clang   $(TARGET)-clang   ; \
	   ln -sf clang++ $(TARGET)-clang++ ; \
	 )
	# ======= Install clang-static-analyzer =======
	@mkdir -p $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/clang-analyzer
	@( cd $(SRC_DIR) ; \
	   cp -r tools/clang/tools/scan-{build,view} \
	         $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/clang-analyzer ; \
	 )
	@( cd $(LLVM_PKG)/usr/bin ; \
	   for i in scan-{build,view} ; do \
	     ln -sf ../lib$(LIBSUFFIX)/clang-analyzer/$$i/$$i $$i ; \
	   done ; \
	   for i in ccc c++ ; do \
	     ln -sf ../lib$(LIBSUFFIX)/clang-analyzer/scan-build/$$i-analyzer $$i-analyzer ; \
	   done ; \
	   sed -i "s|\$RealBin/bin|/usr/bin|" \
	     $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/clang-analyzer/scan-build/scan-build ; \
	   sed -i "s|\$RealBin/sorttable.js|/usr/lib$(LIBSUFFIX)/clang-analyzer/scan-build/sorttable.js|" \
	     $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/clang-analyzer/scan-build/scan-build ; \
	   sed -i "s|\$RealBin/scanview.css|/usr/lib$(LIBSUFFIX)/clang-analyzer/scan-build/scanview.css|" \
	     $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/clang-analyzer/scan-build/scan-build ; \
	 )
	# ======= Remove example libraries =======
	@rm -f $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/LLVMHello*
	@( cd $(LLVM_PKG)/usr/lib$(LIBSUFFIX) ; chmod 0644 *.a )
	# ======= Install Documentation =======
	@mkdir -p $(LLVM_PKG)/usr/share/man/man1
	@mv $(LLVM_PKG)/usr/lib$(LIBSUFFIX)/clang-analyzer/scan-build/scan-build.1 $(LLVM_PKG)/usr/share/man/man1
	@if [ -d $(LLVM_PKG)/usr/share/man ]; then \
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
	# ======= Remove llvm-config-host from target package =======
	@rm -f $(LLVM_PKG)/usr/bin/llvm-config-host
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
