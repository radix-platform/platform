
COMPONENT_TARGETS   = $(HARDWARE_PC64)

NEED_ABS_PATH       = true
COMPONENT_IS_3PP    = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = sources/GNU/libtool

REQUIRES            = dev/libtool/2.4.2

# ======= __END_OF_REQUIRES__ =======


version             = 2.4.2
tar_xz_archive      = $(SRC_PACKAGE_PATH)/GNU/libtool/libtool-$(version).tar.xz
SRC_ARCHIVE         = $(tar_xz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/libtool-$(version)
src_dir_name        = libtool-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir           = $(TARGET_BUILD_DIR)/build
build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBTOOL32_PKG_NAME                = libtool-x32
LIBTOOL32_PKG_VERSION             = 2.4.2
LIBTOOL32_PKG_ARCH                = $(TOOLCHAIN)
LIBTOOL32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBTOOL32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBTOOL32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBTOOL32_PKG_SHORT_DESCRIPTION   = generic library support script
LIBTOOL32_PKG_URL                 = $(BUG_URL)
LIBTOOL32_PKG_LICENSE             = GPLv2
LIBTOOL32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBTOOL32_PKG_NAME)-pkg-description
LIBTOOL32_PKG_DESCRIPTION_FILE_IN = $(LIBTOOL32_PKG_NAME)-pkg-description.in
LIBTOOL32_PKG_INSTALL_SCRIPT      = $(LIBTOOL32_PKG_NAME)-pkg-install.sh

LIBTOOL32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBTOOL32_PKG_NAME)-package

pkg_basename     = $(LIBTOOL32_PKG_NAME)-$(LIBTOOL32_PKG_VERSION)-$(LIBTOOL32_PKG_ARCH)-$(LIBTOOL32_PKG_DISTRO_NAME)-$(LIBTOOL32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBTOOL32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

GCC_VERSION = $(shell $(CC) -dumpversion)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
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
	@mkdir -p $(LIBTOOL32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(LIBTOOL32_PKG)/usr/bin/32
	@( cd $(LIBTOOL32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(LIBTOOL32_PKG)/usr/include
	@rm -rf $(LIBTOOL32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBTOOL32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libltdl.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBTOOL32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libltdl.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libltdl.la \
	 )
	# ======= Tune /usr/bin/32/libtool for target system =======
	@( cd $(LIBTOOL32_PKG)/usr/bin/32 ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libtool ; \
	   sed -i "s,$(TOOLCHAIN_PATH),/usr,g" libtool ; \
	   sed -i "s,AS=.*,AS=\"as\",g" libtool ; \
	   sed -i "s,build_alias=.*,build_alias=$(TARGET32),g" libtool ; \
	   sed -i "s,build=.*,build=$(TARGET32),g" libtool ; \
	   sed -i "s,NM=.*,NM=\"/usr/bin/nm -B\",g" libtool ; \
	   sed -i "s,AR=.*,AR=\"ar\",g" libtool ; \
	   sed -i "s,STRIP=.*,STRIP=\"strip\",g" libtool ; \
	   sed -i "s,RANLIB=.*,RANLIB=\"ranlib\",g" libtool ; \
	   sed -i "s,LTCC=.*,LTCC=\"gcc -m32\",g" libtool ; \
	   sed -i "s,LTCFLAGS=.*,LTCFLAGS=\"$(ARCH_FLAGS)\",g" libtool ; \
	   sed -i "s,sys_lib_search_path_spec=.*,sys_lib_search_path_spec=\"/usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/32 /usr/$(TARGET)/lib32 /usr/lib32 /lib32\",g" libtool ; \
	   sed -i "s,sys_lib_dlsearch_path_spec=.*,sys_lib_dlsearch_path_spec=\"/lib32 /usr/lub32 /lib /usr/lib /usr/$(TARGET)/lib32 /usr/lib32/seamonkey \",g" libtool ; \
	   sed -i "s,old_striplib=.*,old_striplib=\"strip --strip-debug\",g" libtool ; \
	   sed -i "s,striplib=.*,striplib=\"strip --strip-unneeded\",g" libtool ; \
	   sed -i "s,LD=.*,LD=\"/usr/$(TARGET)/bin/ld\",g" libtool ; \
	   sed -i "s,CC=.*,CC=\"gcc -m32\",g" libtool ; \
	 )
	# ======= Tune /usr/bin/32/libtool for FORTRAN compiler (build machine depended) =======
	@( cd $(LIBTOOL32_PKG)/usr/bin/32 ; \
	   begin=`grep -n "BEGIN LIBTOOL TAG CONFIG: FC" libtool | cut -f 1 -d ':'` ; \
	   end=`grep -n "END LIBTOOL TAG CONFIG: FC" libtool | cut -f 1 -d ':'` ; \
	   sed -i "$$begin,$$end s,compiler_lib_search_dirs=.*,compiler_lib_search_dirs=\"/usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/32 /usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/32/../../../../../lib32 /lib/../lib32 /usr/lib/../lib32 /usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/32/../../../../../$(TARGET)/lib32 /usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/32/../../../..\",g" libtool ; \
	   sed -i "$$begin,$$end s,predep_objects=.*,predep_objects=\"/usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/32/../../../../../lib32/crti.o /usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/32/crtbeginS.o\",g" libtool ; \
	   sed -i "$$begin,$$end s,postdep_objects=.*,postdep_objects=\"/usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/32/crtendS.o /usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/32/../../../../../lib32/crtn.o\",g" libtool ; \
	   sed -i "$$begin,$$end s,compiler_lib_search_path=.*,compiler_lib_search_path=\"-L/usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/32 -L/usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/32/../../../../../lib32 -L/lib/../lib32 -L/usr/lib/../lib32 -L/usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/32/../../../../../$(TARGET)/lib32 -L/usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/32/../../../..\",g" libtool ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBTOOL32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBTOOL32_PKG_DESCRIPTION_FILE): $(LIBTOOL32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBTOOL32_PKG_DESCRIPTION_FILE) $(LIBTOOL32_PKG_INSTALL_SCRIPT)
	@cp $(LIBTOOL32_PKG_DESCRIPTION_FILE) $(LIBTOOL32_PKG)/.DESCRIPTION
	@cp $(LIBTOOL32_PKG_INSTALL_SCRIPT) $(LIBTOOL32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBTOOL32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBTOOL32_PKG_NAME)"                            >  $(LIBTOOL32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBTOOL32_PKG_VERSION)"                          >> $(LIBTOOL32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBTOOL32_PKG_ARCH)"                               >> $(LIBTOOL32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBTOOL32_PKG_DISTRO_NAME)"                  >> $(LIBTOOL32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBTOOL32_PKG_DISTRO_VERSION)"                >> $(LIBTOOL32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBTOOL32_PKG_GROUP)"                             >> $(LIBTOOL32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBTOOL32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBTOOL32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBTOOL32_PKG_URL)"                                 >> $(LIBTOOL32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBTOOL32_PKG_LICENSE)"                         >> $(LIBTOOL32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBTOOL32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
