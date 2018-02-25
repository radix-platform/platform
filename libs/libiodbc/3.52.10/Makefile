
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BAIKAL_T1)
COMPONENT_TARGETS += $(HARDWARE_MBC4_PC)
COMPONENT_TARGETS += $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_S824L_LSB)
COMPONENT_TARGETS += $(HARDWARE_VESNIN_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2_LSB)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libiodbc

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.26
else
REQUIRES           = libs/glibc/2.26-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 3.52.10
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libiodbc/libiodbc-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libiodbc-$(version)
src_dir_name       = libiodbc-$(version)
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
LIBIODBC_PKG_NAME                = libiodbc
LIBIODBC_PKG_VERSION             = 3.52.10
LIBIODBC_PKG_ARCH                = $(TOOLCHAIN)
LIBIODBC_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBIODBC_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBIODBC_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
LIBIODBC_PKG_SHORT_DESCRIPTION   = Independent Open DataBase Connectivity
LIBIODBC_PKG_URL                 = $(BUG_URL)
LIBIODBC_PKG_LICENSE             = LGPLv2
LIBIODBC_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBIODBC_PKG_NAME)-pkg-description
LIBIODBC_PKG_DESCRIPTION_FILE_IN = $(LIBIODBC_PKG_NAME)-pkg-description.in
LIBIODBC_PKG_INSTALL_SCRIPT      = $(LIBIODBC_PKG_NAME)-pkg-install.sh

LIBIODBC_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBIODBC_PKG_NAME)-package

pkg_basename     = $(LIBIODBC_PKG_NAME)-$(LIBIODBC_PKG_VERSION)-$(LIBIODBC_PKG_ARCH)-$(LIBIODBC_PKG_DISTRO_NAME)-$(LIBIODBC_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBIODBC_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --disable-gui
extra_configure_switches += --disable-gtktest

extra_configure_switches += --disable-libodbc
extra_configure_switches += --program-prefix=
extra_configure_switches += --program-suffix=

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	@mkdir -p $(LIBIODBC_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@( cd $(LIBIODBC_PKG)/usr/share/man/man1 ; \
	   for file in *.1 ; do                                \
	     ln=`head -n 1 $$file` ;                           \
	     if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	       origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	       origin=`basename $$origin` ;                    \
	       rm -f $$file ;                                  \
	       ln -sf $$origin $$file ;                        \
	     fi ;                                              \
	   done ;                                              \
	 )
	@if [ -d $(LIBIODBC_PKG)/usr/share/man ]; then \
	  ( cd $(LIBIODBC_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBIODBC_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING $(SRC_DIR)/LICENSE* \
	       $(LIBIODBC_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBIODBC_PKG)/usr/share/doc/$(src_dir_name)
	@mv $(LIBIODBC_PKG)/usr/share/libiodbc/samples $(LIBIODBC_PKG)/usr/share/doc/$(src_dir_name)
	@rm -rf $(LIBIODBC_PKG)/usr/share/libiodbc
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING IAFA-PACKAGE INSTALL LICENSE* NEWS README* \
	         $(LIBIODBC_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBIODBC_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBIODBC_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libiodbc.la libiodbcinst.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBIODBC_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libiodbc.la libiodbcinst.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libiodbc.la libiodbcinst.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libiodbc.pc ; \
	   sed -i "s,/etc,$(TARGET_DEST_DIR)/etc,g" libiodbc.pc ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" iodbc-config ; \
	   sed -i "s,/usr/lib,$(TARGET_DEST_DIR)/usr/lib,g"       iodbc-config ; \
	   sed -i "s,/etc,$(TARGET_DEST_DIR)/etc,g"               iodbc-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBIODBC_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBIODBC_PKG_DESCRIPTION_FILE): $(LIBIODBC_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBIODBC_PKG_DESCRIPTION_FILE) $(LIBIODBC_PKG_INSTALL_SCRIPT)
	@cp $(LIBIODBC_PKG_DESCRIPTION_FILE) $(LIBIODBC_PKG)/.DESCRIPTION
	@cp $(LIBIODBC_PKG_INSTALL_SCRIPT) $(LIBIODBC_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBIODBC_PKG)/.REQUIRES
	@echo "pkgname=$(LIBIODBC_PKG_NAME)"                            >  $(LIBIODBC_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBIODBC_PKG_VERSION)"                          >> $(LIBIODBC_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBIODBC_PKG_ARCH)"                               >> $(LIBIODBC_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBIODBC_PKG_DISTRO_NAME)"                  >> $(LIBIODBC_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBIODBC_PKG_DISTRO_VERSION)"                >> $(LIBIODBC_PKG)/.PKGINFO ; \
	 echo "group=$(LIBIODBC_PKG_GROUP)"                             >> $(LIBIODBC_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBIODBC_PKG_SHORT_DESCRIPTION)\"" >> $(LIBIODBC_PKG)/.PKGINFO ; \
	 echo "url=$(LIBIODBC_PKG_URL)"                                 >> $(LIBIODBC_PKG)/.PKGINFO ; \
	 echo "license=$(LIBIODBC_PKG_LICENSE)"                         >> $(LIBIODBC_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBIODBC_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
