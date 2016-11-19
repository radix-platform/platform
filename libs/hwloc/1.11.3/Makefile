
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


SOURCE_REQUIRES    = sources/packages/l/hwloc

REQUIRES           = X11/libs/cairo/1.14.6
REQUIRES          += X11/X.org/lib/libpciaccess/0.13.4
REQUIRES          += libs/libxml2/2.9.3
REQUIRES          += app/pciutils/3.4.1

# ======= __END_OF_REQUIRES__ =======


version            = 1.11.3
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/hwloc/hwloc-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/hwloc-$(version)
src_dir_name       = hwloc-$(version)
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
HWLOC_PKG_NAME                = hwloc
HWLOC_PKG_VERSION             = 1.11.3
HWLOC_PKG_ARCH                = $(TOOLCHAIN)
HWLOC_PKG_DISTRO_NAME         = $(DISTRO_NAME)
HWLOC_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
HWLOC_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
HWLOC_PKG_SHORT_DESCRIPTION   = Portable Hardware Locality
HWLOC_PKG_URL                 = $(BUG_URL)
HWLOC_PKG_LICENSE             = BSD
HWLOC_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(HWLOC_PKG_NAME)-pkg-description
HWLOC_PKG_DESCRIPTION_FILE_IN = $(HWLOC_PKG_NAME)-pkg-description.in
HWLOC_PKG_INSTALL_SCRIPT      = $(HWLOC_PKG_NAME)-pkg-install.sh

HWLOC_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(HWLOC_PKG_NAME)-package

pkg_basename     = $(HWLOC_PKG_NAME)-$(HWLOC_PKG_VERSION)-$(HWLOC_PKG_ARCH)-$(HWLOC_PKG_DISTRO_NAME)-$(HWLOC_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(HWLOC_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
#
# Fix cpuid-x86 build error with gcc -O3 on x86-32.
# Thanks to Thomas Van Doren for reporting the issue.
#
OPTIMIZATION_FLAGS = -O2
endif


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
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
	@mkdir -p $(HWLOC_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@cp $(SRC_DIR)/doc/doxygen-doc/man/man3/hwlocality_info_attr.3 \
	    $(HWLOC_PKG)/usr/share/man/man3
	@( cd $(HWLOC_PKG)/usr/share/man/man3 ; \
	   for file in *.3 ; do                                \
	     ln=`head -n 1 $$file` ;                           \
	     if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	       origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	       origin=`basename $$origin` ;                    \
	       rm -f $$file ;                                  \
	       ln -sf $$origin $$file ;                        \
	     fi ;                                              \
	   done ;                                              \
	 )
	@if [ -d $(HWLOC_PKG)/usr/share/man ]; then \
	  ( cd $(HWLOC_PKG)/usr/share/man ; \
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
	@mkdir -p $(HWLOC_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(HWLOC_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(HWLOC_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING NEWS README VERSION doc/doxygen-doc/html \
	         $(HWLOC_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@rm -f $(HWLOC_PKG)/usr/share/doc/$(src_dir_name)/hwloc-letter.pdf
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(HWLOC_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(HWLOC_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libhwloc.la  \
	 )
	@( cd $(HWLOC_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" hwloc.pc  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(HWLOC_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libhwloc.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libhwloc.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" hwloc.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(HWLOC_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(HWLOC_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(HWLOC_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(HWLOC_PKG_DESCRIPTION_FILE): $(HWLOC_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(HWLOC_PKG_DESCRIPTION_FILE) $(HWLOC_PKG_INSTALL_SCRIPT)
	@cp $(HWLOC_PKG_DESCRIPTION_FILE) $(HWLOC_PKG)/.DESCRIPTION
	@cp $(HWLOC_PKG_INSTALL_SCRIPT) $(HWLOC_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(HWLOC_PKG)/.REQUIRES
	@echo "pkgname=$(HWLOC_PKG_NAME)"                            >  $(HWLOC_PKG)/.PKGINFO ; \
	 echo "pkgver=$(HWLOC_PKG_VERSION)"                          >> $(HWLOC_PKG)/.PKGINFO ; \
	 echo "arch=$(HWLOC_PKG_ARCH)"                               >> $(HWLOC_PKG)/.PKGINFO ; \
	 echo "distroname=$(HWLOC_PKG_DISTRO_NAME)"                  >> $(HWLOC_PKG)/.PKGINFO ; \
	 echo "distrover=$(HWLOC_PKG_DISTRO_VERSION)"                >> $(HWLOC_PKG)/.PKGINFO ; \
	 echo "group=$(HWLOC_PKG_GROUP)"                             >> $(HWLOC_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(HWLOC_PKG_SHORT_DESCRIPTION)\"" >> $(HWLOC_PKG)/.PKGINFO ; \
	 echo "url=$(HWLOC_PKG_URL)"                                 >> $(HWLOC_PKG)/.PKGINFO ; \
	 echo "license=$(HWLOC_PKG_LICENSE)"                         >> $(HWLOC_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(HWLOC_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
