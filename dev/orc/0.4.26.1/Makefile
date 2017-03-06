
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
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/orc

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.24
else
REQUIRES           = libs/glibc/2.24-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.4.26.1
short_version      = $(shell echo $(version) | cut -f 1,2 -d '.' )
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/d/orc/orc-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/orc-$(version)
src_dir_name       = orc-$(version)
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
ORC_PKG_NAME                = orc
ORC_PKG_VERSION             = 0.4.26.1
ORC_PKG_ARCH                = $(TOOLCHAIN)
ORC_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ORC_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ORC_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
ORC_PKG_SHORT_DESCRIPTION   = Optimized Inner Loop Runtime Compiler
ORC_PKG_URL                 = $(BUG_URL)
ORC_PKG_LICENSE             = custom
ORC_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ORC_PKG_NAME)-pkg-description
ORC_PKG_DESCRIPTION_FILE_IN = $(ORC_PKG_NAME)-pkg-description.in
ORC_PKG_INSTALL_SCRIPT      = $(ORC_PKG_NAME)-pkg-install.sh

ORC_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ORC_PKG_NAME)-package

pkg_basename     = $(ORC_PKG_NAME)-$(ORC_PKG_VERSION)-$(ORC_PKG_ARCH)-$(ORC_PKG_DISTRO_NAME)-$(ORC_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(ORC_PKG)


ENABLE_GTK_DOCUMENTATION  = yes

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)      \
                            $(HARDWARE_CB2X)      \
                            $(HARDWARE_CB3X)      \
                            $(HARDWARE_FFRK3288)  \
                            $(HARDWARE_M201)      \
                            $(HARDWARE_MXV)       \
                            $(HARDWARE_NIT6Q)     \
                            $(HARDWARE_OMAP5UEVM) \
                            $(HARDWARE_DRA7XXEVM)),)
extra_configure_switches += --enable-backend=neon
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_P201) $(HARDWARE_NEXBOX_A95X) \
                                             $(HARDWARE_ODROID_C2)   \
                            $(HARDWARE_P212) $(HARDWARE_KHADAS_VIM)  \
                            $(HARDWARE_Q201) $(HARDWARE_ENYBOX_X2)),)
extra_configure_switches += --enable-backend=neon
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
extra_configure_switches += --enable-backend=sse,mmx
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
extra_configure_switches += --enable-backend=sse,mmx
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20) $(HARDWARE_BT1)),)
extra_configure_switches += --enable-backend=mips
endif

extra_configure_switches += --enable-gtk-doc=no

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


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
	@mkdir -p $(ORC_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
ifeq ($(ENABLE_GTK_DOCUMENTATION),yes)
	# ======= Install Documentation =======
	@( cd $(SRC_DIR) ; \
	   ./configure --prefix=/usr --enable-gtk-doc ; \
	   make -C doc ; \
	   make -C doc install $(env_sysroot) ; \
	 )
endif
	@if [ -d $(ORC_PKG)/usr/share/man ]; then \
	  ( cd $(ORC_PKG)/usr/share/man ; \
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
	@mkdir -p $(ORC_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(ORC_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(ORC_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README RELEASE ROADMAP TODO \
	         $(ORC_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
ifeq ($(ENABLE_GTK_DOCUMENTATION),yes)
	@( cd $(ORC_PKG)/usr/share/doc/$(src_dir_name) ; \
	   ln -sf ../../gtk-doc/html/orc html ; \
	 )
endif
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(ORC_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(ORC_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" liborc-$(short_version).la liborc-test-$(short_version).la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ORC_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" liborc-$(short_version).la liborc-test-$(short_version).la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" liborc-$(short_version).la liborc-test-$(short_version).la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" orc-$(short_version).pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(ORC_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(ORC_PKG_DESCRIPTION_FILE): $(ORC_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ORC_PKG_DESCRIPTION_FILE) $(ORC_PKG_INSTALL_SCRIPT)
	@cp $(ORC_PKG_DESCRIPTION_FILE) $(ORC_PKG)/.DESCRIPTION
	@cp $(ORC_PKG_INSTALL_SCRIPT) $(ORC_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ORC_PKG)/.REQUIRES
	@echo "pkgname=$(ORC_PKG_NAME)"                            >  $(ORC_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ORC_PKG_VERSION)"                          >> $(ORC_PKG)/.PKGINFO ; \
	 echo "arch=$(ORC_PKG_ARCH)"                               >> $(ORC_PKG)/.PKGINFO ; \
	 echo "distroname=$(ORC_PKG_DISTRO_NAME)"                  >> $(ORC_PKG)/.PKGINFO ; \
	 echo "distrover=$(ORC_PKG_DISTRO_VERSION)"                >> $(ORC_PKG)/.PKGINFO ; \
	 echo "group=$(ORC_PKG_GROUP)"                             >> $(ORC_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ORC_PKG_SHORT_DESCRIPTION)\"" >> $(ORC_PKG)/.PKGINFO ; \
	 echo "url=$(ORC_PKG_URL)"                                 >> $(ORC_PKG)/.PKGINFO ; \
	 echo "license=$(ORC_PKG_LICENSE)"                         >> $(ORC_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(ORC_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
