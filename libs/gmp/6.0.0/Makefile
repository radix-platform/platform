
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/gmp

ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.22
else
REQUIRES           = libs/glibc/2.22-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 6.0.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/GNU/gmp/gmp-$(version)a.tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gmp-$(version)
src_dir_name       = gmp-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_OMAP543X_GLIBC))
OPT_PATCHES = PATCHES.omap543x
endif

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GMP_PKG_NAME                = gmp
GMP_PKG_VERSION             = 6.0.0
GMP_PKG_ARCH                = $(TOOLCHAIN)
GMP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GMP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GMP_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
GMP_PKG_SHORT_DESCRIPTION   = GNU multiple precision arithmetic library
GMP_PKG_URL                 = $(BUG_URL)
GMP_PKG_LICENSE             = GPLv2
GMP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GMP_PKG_NAME)-pkg-description
GMP_PKG_DESCRIPTION_FILE_IN = $(GMP_PKG_NAME)-pkg-description.in
GMP_PKG_INSTALL_SCRIPT      = $(GMP_PKG_NAME)-pkg-install.sh

GMP_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GMP_PKG_NAME)-package

pkg_basename     = $(GMP_PKG_NAME)-$(GMP_PKG_VERSION)-$(GMP_PKG_ARCH)-$(GMP_PKG_DISTRO_NAME)-$(GMP_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(GMP_PKG)

CPPFLAGS    += -fexceptions

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --with-gnu-ld
extra_configure_switches += --enable-cxx
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	$(APPLY_OPT_PATCHES)
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
	@mkdir -p $(GMP_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(GMP_PKG)/usr/share/info/dir
	@gzip -9 $(GMP_PKG)/usr/share/info/*
	@if [ -d $(GMP_PKG)/usr/share/man ]; then \
	  ( cd $(GMP_PKG)/usr/share/man ; \
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
	@mkdir -p $(GMP_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* $(SRC_DIR)/INSTALL* \
	       $(SRC_DIR)/NEWS $(SRC_DIR)/README \
	       $(GMP_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GMP_PKG)/usr/share/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/doc/projects.html $(SRC_DIR)/doc/tasks.html \
	       $(GMP_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GMP_PKG)/usr/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GMP_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgmp.la ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgmpxx.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GMP_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgmp.la ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgmpxx.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgmp.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgmpxx.la \
	 )
	# ======= Strip binaries =======
	@( cd $(GMP_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GMP_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GMP_PKG_DESCRIPTION_FILE): $(GMP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GMP_PKG_DESCRIPTION_FILE) $(GMP_PKG_INSTALL_SCRIPT)
	@cp $(GMP_PKG_DESCRIPTION_FILE) $(GMP_PKG)/.DESCRIPTION
	@cp $(GMP_PKG_INSTALL_SCRIPT) $(GMP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GMP_PKG)/.REQUIRES
	@echo "pkgname=$(GMP_PKG_NAME)"                            >  $(GMP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GMP_PKG_VERSION)"                          >> $(GMP_PKG)/.PKGINFO ; \
	 echo "arch=$(GMP_PKG_ARCH)"                               >> $(GMP_PKG)/.PKGINFO ; \
	 echo "distroname=$(GMP_PKG_DISTRO_NAME)"                  >> $(GMP_PKG)/.PKGINFO ; \
	 echo "distrover=$(GMP_PKG_DISTRO_VERSION)"                >> $(GMP_PKG)/.PKGINFO ; \
	 echo "group=$(GMP_PKG_GROUP)"                             >> $(GMP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GMP_PKG_SHORT_DESCRIPTION)\"" >> $(GMP_PKG)/.PKGINFO ; \
	 echo "url=$(GMP_PKG_URL)"                                 >> $(GMP_PKG)/.PKGINFO ; \
	 echo "license=$(GMP_PKG_LICENSE)"                         >> $(GMP_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GMP_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
