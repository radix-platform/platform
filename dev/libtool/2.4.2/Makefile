
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXQ)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/libtool

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.23
else
REQUIRES           = libs/glibc/2.23-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 2.4.2
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNU/libtool/libtool-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libtool-$(version)
src_dir_name       = libtool-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done



####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBTOOL_PKG_NAME                = libtool
LIBTOOL_PKG_VERSION             = 2.4.2
LIBTOOL_PKG_ARCH                = $(TOOLCHAIN)
LIBTOOL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBTOOL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBTOOL_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
LIBTOOL_PKG_SHORT_DESCRIPTION   = generic library support script
LIBTOOL_PKG_URL                 = $(BUG_URL)
LIBTOOL_PKG_LICENSE             = GPLv2
LIBTOOL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBTOOL_PKG_NAME)-pkg-description
LIBTOOL_PKG_DESCRIPTION_FILE_IN = $(LIBTOOL_PKG_NAME)-pkg-description.in
LIBTOOL_PKG_INSTALL_SCRIPT      = $(LIBTOOL_PKG_NAME)-pkg-install.sh

LIBTOOL_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBTOOL_PKG_NAME)-package

pkg_basename     = $(LIBTOOL_PKG_NAME)-$(LIBTOOL_PKG_VERSION)-$(LIBTOOL_PKG_ARCH)-$(LIBTOOL_PKG_DISTRO_NAME)-$(LIBTOOL_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBTOOL_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
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
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBTOOL_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(LIBTOOL_PKG)/usr/share/info/dir
	@gzip -9 $(LIBTOOL_PKG)/usr/share/info/*
	@if [ -d $(LIBTOOL_PKG)/usr/share/man ]; then \
	  ( cd $(LIBTOOL_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBTOOL_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBTOOL_PKG)/usr/share/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(LIBTOOL_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBTOOL_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README THANKS TODO \
	         $(LIBTOOL_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBTOOL_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBTOOL_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libltdl.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBTOOL_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libltdl.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libltdl.la \
	 )
	# ======= Tune /usr/bin/libtool for target system =======
	@( cd $(LIBTOOL_PKG)/usr/bin ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libtool ; \
	   sed -i "s,$(TOOLCHAIN_PATH),/usr,g" libtool ; \
	   sed -i "s,AS=.*,AS=\"as\",g" libtool ; \
	   sed -i "s,build_alias=.*,build_alias=$(TARGET),g" libtool ; \
	   sed -i "s,build=.*,build=$(TARGET),g" libtool ; \
	   sed -i "s,NM=.*,NM=\"/usr/bin/nm -B\",g" libtool ; \
	   sed -i "s,AR=.*,AR=\"ar\",g" libtool ; \
	   sed -i "s,STRIP=.*,STRIP=\"strip\",g" libtool ; \
	   sed -i "s,RANLIB=.*,RANLIB=\"ranlib\",g" libtool ; \
	   sed -i "s,LTCC=.*,LTCC=\"gcc\",g" libtool ; \
	   sed -i "s,LTCFLAGS=.*,LTCFLAGS=\"$(ARCH_FLAGS)\",g" libtool ; \
	   sed -i "s,sys_lib_search_path_spec=.*,sys_lib_search_path_spec=\"/usr/lib/gcc/$(TARGET)/$(GCC_VERSION) /usr/$(TARGET)/lib /usr/lib /lib\",g" libtool ; \
	   sed -i "s,sys_lib_dlsearch_path_spec=.*,sys_lib_dlsearch_path_spec=\"/lib /usr/lib /usr/$(TARGET)/lib /usr/lib/seamonkey \",g" libtool ; \
	   sed -i "s,old_striplib=.*,old_striplib=\"strip --strip-debug\",g" libtool ; \
	   sed -i "s,striplib=.*,striplib=\"strip --strip-unneeded\",g" libtool ; \
	   sed -i "s,LD=.*,LD=\"/usr/$(TARGET)/bin/ld\",g" libtool ; \
	   sed -i "s,CC=.*,CC=\"gcc\",g" libtool ; \
	 )
	# ======= Tune /usr/bin/libtool for FORTRAN compiler (build machine depended) =======
	@( cd $(LIBTOOL_PKG)/usr/bin ; \
	   begin=`grep -n "BEGIN LIBTOOL TAG CONFIG: FC" libtool | cut -f 1 -d ':'` ; \
	   end=`grep -n "END LIBTOOL TAG CONFIG: FC" libtool | cut -f 1 -d ':'` ; \
	   sed -i "$$begin,$$end s,compiler_lib_search_dirs=.*,compiler_lib_search_dirs=\"/usr/lib/gcc/$(TARGET)/$(GCC_VERSION) /usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/../../../../lib /lib/../lib /usr/lib/../lib /usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/../../../../$(TARGET)/lib /usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/../../..\",g" libtool ; \
	   sed -i "$$begin,$$end s,predep_objects=.*,predep_objects=\"/usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/32/../../../../../lib32/crti.o /usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/32/crtbeginS.o\",g" libtool ; \
	   sed -i "$$begin,$$end s,postdep_objects=.*,postdep_objects=\"/usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/32/crtendS.o /usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/32/../../../../../lib32/crtn.o\",g" libtool ; \
	   sed -i "$$begin,$$end s,compiler_lib_search_path=.*,compiler_lib_search_path=\"-L/usr/lib/gcc/$(TARGET)/$(GCC_VERSION) -L/usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/../../../../lib -L/lib/../lib -L/usr/lib/../lib -L/usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/../../../../$(TARGET)/lib -L/usr/lib/gcc/$(TARGET)/$(GCC_VERSION)/../../..\",g" libtool ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBTOOL_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBTOOL_PKG_DESCRIPTION_FILE): $(LIBTOOL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBTOOL_PKG_DESCRIPTION_FILE) $(LIBTOOL_PKG_INSTALL_SCRIPT)
	@cp $(LIBTOOL_PKG_DESCRIPTION_FILE) $(LIBTOOL_PKG)/.DESCRIPTION
	@cp $(LIBTOOL_PKG_INSTALL_SCRIPT) $(LIBTOOL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBTOOL_PKG)/.REQUIRES
	@echo "pkgname=$(LIBTOOL_PKG_NAME)"                            >  $(LIBTOOL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBTOOL_PKG_VERSION)"                          >> $(LIBTOOL_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBTOOL_PKG_ARCH)"                               >> $(LIBTOOL_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBTOOL_PKG_DISTRO_NAME)"                  >> $(LIBTOOL_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBTOOL_PKG_DISTRO_VERSION)"                >> $(LIBTOOL_PKG)/.PKGINFO ; \
	 echo "group=$(LIBTOOL_PKG_GROUP)"                             >> $(LIBTOOL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBTOOL_PKG_SHORT_DESCRIPTION)\"" >> $(LIBTOOL_PKG)/.PKGINFO ; \
	 echo "url=$(LIBTOOL_PKG_URL)"                                 >> $(LIBTOOL_PKG)/.PKGINFO ; \
	 echo "license=$(LIBTOOL_PKG_LICENSE)"                         >> $(LIBTOOL_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBTOOL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
