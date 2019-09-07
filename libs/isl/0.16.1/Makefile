
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
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BAIKAL_T1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/isl

REQUIRES           = libs/gmp/6.1.0

# ======= __END_OF_REQUIRES__ =======


version            = 0.16.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/isl/isl-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/isl-$(version)
src_dir_name       = isl-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ISL_PKG_NAME                = isl
ISL_PKG_VERSION             = 0.16.1
ISL_PKG_ARCH                = $(TOOLCHAIN)
ISL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ISL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ISL_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
ISL_PKG_SHORT_DESCRIPTION   = Integer Set Library
ISL_PKG_URL                 = $(BUG_URL)
ISL_PKG_LICENSE             = MIT
ISL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ISL_PKG_NAME)-pkg-description
ISL_PKG_DESCRIPTION_FILE_IN = $(ISL_PKG_NAME)-pkg-description.in
ISL_PKG_INSTALL_SCRIPT      = $(ISL_PKG_NAME)-pkg-install.sh

ISL_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ISL_PKG_NAME)-package

pkg_basename     = $(ISL_PKG_NAME)-$(ISL_PKG_VERSION)-$(ISL_PKG_ARCH)-$(ISL_PKG_DISTRO_NAME)-$(ISL_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))


BUILD_TARGETS    = $(build_cloog_pkg)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(ISL_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --with-gnu-ld
extra_configure_switches += --with-int=gmp
extra_configure_switches += --with-clang=no
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


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
	@mkdir -p $(ISL_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -f $(ISL_PKG)/usr/lib$(LIBSUFFIX)/libisl.so.*-gdb.py
	# ======= Install Documentation =======
	@mkdir -p $(ISL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/LICENSE \
	       $(ISL_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(ISL_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS GIT_HEAD_ID LICENSE README doc/manual.pdf \
	       $(ISL_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(ISL_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(ISL_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libisl.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ISL_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libisl.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libisl.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" isl.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(ISL_PKG) ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(ISL_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(ISL_PKG_DESCRIPTION_FILE): $(ISL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ISL_PKG_DESCRIPTION_FILE) $(ISL_PKG_INSTALL_SCRIPT)
	@cp $(ISL_PKG_DESCRIPTION_FILE) $(ISL_PKG)/.DESCRIPTION
	@cp $(ISL_PKG_INSTALL_SCRIPT) $(ISL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ISL_PKG)/.REQUIRES
	@echo "pkgname=$(ISL_PKG_NAME)"                            >  $(ISL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ISL_PKG_VERSION)"                          >> $(ISL_PKG)/.PKGINFO ; \
	 echo "arch=$(ISL_PKG_ARCH)"                               >> $(ISL_PKG)/.PKGINFO ; \
	 echo "distroname=$(ISL_PKG_DISTRO_NAME)"                  >> $(ISL_PKG)/.PKGINFO ; \
	 echo "distrover=$(ISL_PKG_DISTRO_VERSION)"                >> $(ISL_PKG)/.PKGINFO ; \
	 echo "group=$(ISL_PKG_GROUP)"                             >> $(ISL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ISL_PKG_SHORT_DESCRIPTION)\"" >> $(ISL_PKG)/.PKGINFO ; \
	 echo "url=$(ISL_PKG_URL)"                                 >> $(ISL_PKG)/.PKGINFO ; \
	 echo "license=$(ISL_PKG_LICENSE)"                         >> $(ISL_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(ISL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
