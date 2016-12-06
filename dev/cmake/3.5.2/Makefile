
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/cmake

ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/libarchive/3.1.2
else
REQUIRES           = libs/libarchive/3.1.2-x86_32
endif
REQUIRES          += libs/shared-mime-info/1.6
REQUIRES          += net/curl/7.47.0

# ======= __END_OF_REQUIRES__ =======


version            = 3.5.2
major_version      = $(shell echo $(version) | cut -f1,2 -d '.')
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/d/cmake/cmake-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/cmake-$(version)
src_dir_name       = cmake-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

manpages           = $(CURDIR)/manpages

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

devenv_dir_name    = build-machine
devenv_dir         = $(TARGET_BUILD_DIR)/$(devenv_dir_name)


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
CMAKE_PKG_NAME                = cmake
CMAKE_PKG_VERSION             = 3.5.2
CMAKE_PKG_ARCH                = $(TOOLCHAIN)
CMAKE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CMAKE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CMAKE_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
CMAKE_PKG_SHORT_DESCRIPTION   = open-source make system
CMAKE_PKG_URL                 = $(BUG_URL)
CMAKE_PKG_LICENSE             = custom
CMAKE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CMAKE_PKG_NAME)-pkg-description
CMAKE_PKG_DESCRIPTION_FILE_IN = $(CMAKE_PKG_NAME)-pkg-description.in
CMAKE_PKG_INSTALL_SCRIPT      = $(CMAKE_PKG_NAME)-pkg-install.sh

CMAKE_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CMAKE_PKG_NAME)-package

pkg_basename     = $(CMAKE_PKG_NAME)-$(CMAKE_PKG_VERSION)-$(CMAKE_PKG_ARCH)-$(CMAKE_PKG_DISTRO_NAME)-$(CMAKE_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(CMAKE_PKG)


extra_configure_switches  = --docdir=share/doc/$(src_dir_name)
extra_configure_switches += --mandir=share/man
extra_configure_switches += --enable-ccache

extra_configure_switches += --no-qt-gui
extra_configure_switches += --no-system-jsoncpp

extra_configure_switches += --system-curl
extra_configure_switches += --system-expat
extra_configure_switches += --system-zlib
extra_configure_switches += --system-bzip2
extra_configure_switches += --system-libarchive


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	# ====== compile 'build-machine' cmake =======
	@( cd $(build_dir) ; \
	   ../$(src_dir_name)/bootstrap --prefix=/usr $(extra_configure_switches) ; \
	 )
	@( cd $(build_dir) ; \
	   ../$(src_dir_name)/configure --prefix=/usr $(extra_configure_switches) ; \
	 )
	@mkdir -p $(devenv_dir)
	@( cd $(build_dir) ; \
	   $(MAKE) ; \
	   $(MAKE) -j1 install DESTDIR=../$(devenv_dir_name) ; \
	 )
	@rm -rf $(build_dir)
	@mkdir -p $(build_dir)
	# ====== compile '$(HARDWARE)' cmake =======
	@( cd $(build_dir) ; \
	   $(BUILD_ENVIRONMENT) cmake -DCMAKE_INSTALL_PREFIX="$(CMAKE_PKG)/usr"           \
	                              -DCMAKE_FIND_ROOT_PATH="$(TARGET_DEST_DIR)"         \
	                              -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM="NEVER"         \
	                              -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY="ONLY"          \
	                              -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE="ONLY"          \
	                              -DCMAKE_DOC_DIR="share/doc/$(src_dir_name)"         \
	                              -DCMAKE_USE_SYSTEM_JSONCPP=OFF                      \
	                              -DCMAKE_USE_SYSTEM_CURL=ON                          \
	                              -DCMAKE_USE_SYSTEM_EXPAT=ON                         \
	                              -DCMAKE_USE_SYSTEM_LIBARCHIVE=ON                    \
	                              -DCMAKE_USE_SYSTEM_BZIP2=ON                         \
	                              -DCMAKE_USE_SYSTEM_LIBLZMA=ON                       \
	                              -DCMAKE_USE_SYSTEM_ZLIB=ON                          \
	                                                           "../$(src_dir_name)" ; \
	 )
	@( cd $(build_dir) ; \
	   sed -i "s,^[ \t]*bin/cmake,\t\.\./$(devenv_dir_name)/usr/bin/cmake,g" Makefile ; \
	 )
	@cd $(build_dir) && $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(CMAKE_PKG)
	@cd $(build_dir) && $(MAKE) -j1 install
	# ======= Install Documentation =======
	@mkdir -p $(CMAKE_PKG)/usr/share/man/man{1,7}
	@for file in ccmake cmake cmake-gui cpack ctest ; do \
	   cp -a $(manpages)/man1/$${file}.1 $(CMAKE_PKG)/usr/share/man/man1/$${file}.1 ; \
	 done
	@for file in cmake-buildsystem cmake-commands cmake-compile-features      \
	             cmake-developer cmake-generator-expressions cmake-generators \
	             cmake-language cmake-modules cmake-packages cmake-policies   \
	             cmake-properties cmake-qt cmake-toolchains cmake-variables   ; do \
	   cp -a $(manpages)/man7/$${file}.7 $(CMAKE_PKG)/usr/share/man/man7/$${file}.7 ; \
	 done
	# ======= Compress manpages =======
	@if [ -d $(CMAKE_PKG)/usr/share/man ]; then \
	  ( cd $(CMAKE_PKG)/usr/share/man ; \
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
	@mkdir -p $(CMAKE_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/Copyright.txt \
	       $(CMAKE_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(CMAKE_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog.txt ]; then \
	     DOCSDIR=`echo $(CMAKE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog.txt | head -n 1000 > $$DOCSDIR/ChangeLog.txt ; \
	     touch -r ChangeLog.txt $$DOCSDIR/ChangeLog.txt ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(CMAKE_PKG))
	# ======= Strip binaries =======
	@( cd $(CMAKE_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(CMAKE_PKG_DESCRIPTION_FILE): $(CMAKE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CMAKE_PKG_DESCRIPTION_FILE) $(CMAKE_PKG_INSTALL_SCRIPT)
	@cp $(CMAKE_PKG_DESCRIPTION_FILE) $(CMAKE_PKG)/.DESCRIPTION
	@cp $(CMAKE_PKG_INSTALL_SCRIPT) $(CMAKE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CMAKE_PKG)/.REQUIRES
	@echo "pkgname=$(CMAKE_PKG_NAME)"                            >  $(CMAKE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CMAKE_PKG_VERSION)"                          >> $(CMAKE_PKG)/.PKGINFO ; \
	 echo "arch=$(CMAKE_PKG_ARCH)"                               >> $(CMAKE_PKG)/.PKGINFO ; \
	 echo "distroname=$(CMAKE_PKG_DISTRO_NAME)"                  >> $(CMAKE_PKG)/.PKGINFO ; \
	 echo "distrover=$(CMAKE_PKG_DISTRO_VERSION)"                >> $(CMAKE_PKG)/.PKGINFO ; \
	 echo "group=$(CMAKE_PKG_GROUP)"                             >> $(CMAKE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CMAKE_PKG_SHORT_DESCRIPTION)\"" >> $(CMAKE_PKG)/.PKGINFO ; \
	 echo "url=$(CMAKE_PKG_URL)"                                 >> $(CMAKE_PKG)/.PKGINFO ; \
	 echo "license=$(CMAKE_PKG_LICENSE)"                         >> $(CMAKE_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(CMAKE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
