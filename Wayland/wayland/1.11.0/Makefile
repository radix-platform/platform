
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP2E)
COMPONENT_TARGETS += $(HARDWARE_NANOPI_NEO)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PL2)
COMPONENT_TARGETS += $(HARDWARE_WECHIP_TX6)
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


SOURCE_REQUIRES    = sources/Wayland/wayland

REQUIRES           = libs/expat/2.1.1
REQUIRES          += libs/libffi/3.2.1
REQUIRES          += libs/libxml2/2.9.3

# ======= __END_OF_REQUIRES__ =======


version            = 1.11.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/Wayland/wayland/wayland-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/wayland-$(version)
src_dir_name       = wayland-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = wayland

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
WAYLAND_PKG_NAME                = wayland
WAYLAND_PKG_VERSION             = 1.11.0
WAYLAND_PKG_ARCH                = $(TOOLCHAIN)
WAYLAND_PKG_DISTRO_NAME         = $(DISTRO_NAME)
WAYLAND_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
WAYLAND_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
WAYLAND_PKG_SHORT_DESCRIPTION   = C implementation of the Wayland protocol
WAYLAND_PKG_URL                 = $(BUG_URL)
WAYLAND_PKG_LICENSE             = custom
WAYLAND_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(WAYLAND_PKG_NAME)-pkg-description
WAYLAND_PKG_DESCRIPTION_FILE_IN = $(WAYLAND_PKG_NAME)-pkg-description.in
WAYLAND_PKG_INSTALL_SCRIPT      = $(WAYLAND_PKG_NAME)-pkg-install.sh

WAYLAND_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(WAYLAND_PKG_NAME)-package

pkg_basename     = $(WAYLAND_PKG_NAME)-$(WAYLAND_PKG_VERSION)-$(WAYLAND_PKG_ARCH)-$(WAYLAND_PKG_DISTRO_NAME)-$(WAYLAND_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(WAYLAND_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   autoreconf -i ; \
	 )
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
	@mkdir -p $(WAYLAND_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@for file in wayland-util.h.3 wayland-util.c.3     \
	             wayland-server.h.3 wayland-server.c.3 \
	             wayland-client.c.3   \
	             wayland-server-core.h.3 wayland-client-core.h.3 \
	             wayland-shm.c.3 ; do \
	   cat $(CURDIR)/$(build_dir)/doc/doxygen/man/man3/$$file | \
	       sed "s,$(CURDIR)/$(SRC_DIR)/src/,,g" > $(WAYLAND_PKG)/usr/share/man/man3/$$file ; \
	 done
	@( cd $(WAYLAND_PKG)/usr/share/man/man3 ; \
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
	@if [ -d $(WAYLAND_PKG)/usr/share/man ]; then \
	  ( cd $(WAYLAND_PKG)/usr/share/man ; \
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
	@mkdir -p $(WAYLAND_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(WAYLAND_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(WAYLAND_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README TODO \
	         $(WAYLAND_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(WAYLAND_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(WAYLAND_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libwayland-client.la   \
	                                    libwayland-cursor.la   \
	                                    libwayland-server.la ; \
	 )
	# ======= create symbolic link to pkgconfig wayland-scanner.pc file  =======
	@( cd $(WAYLAND_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   ln -sf wayland-scanner.pc wayland_scanner.pc ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(WAYLAND_PKG))
	# ======= Install wayland-scanner into $(TARGET_DEST_DIR) =======
	@cp -a $(build_dir)/build-wayland-scanner $(TARGET_DEST_DIR)/usr/bin/$(TARGET)-wayland-scanner
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libwayland-client.la   \
	                                            libwayland-cursor.la   \
	                                            libwayland-server.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libwayland-client.la   \
	                                              libwayland-cursor.la   \
	                                              libwayland-server.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" wayland-client.pc   \
	                                            wayland-cursor.pc   \
	                                            wayland-scanner.pc  \
	                                            wayland-server.pc ; \
	   sed -i "s,/bin/wayland-scanner,/bin/$(TARGET)-wayland-scanner,g" wayland-scanner.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(WAYLAND_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(WAYLAND_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(WAYLAND_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(WAYLAND_PKG_DESCRIPTION_FILE): $(WAYLAND_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(WAYLAND_PKG_DESCRIPTION_FILE) $(WAYLAND_PKG_INSTALL_SCRIPT)
	@cp $(WAYLAND_PKG_DESCRIPTION_FILE) $(WAYLAND_PKG)/.DESCRIPTION
	@cp $(WAYLAND_PKG_INSTALL_SCRIPT) $(WAYLAND_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(WAYLAND_PKG)/.REQUIRES
	@echo "pkgname=$(WAYLAND_PKG_NAME)"                            >  $(WAYLAND_PKG)/.PKGINFO ; \
	 echo "pkgver=$(WAYLAND_PKG_VERSION)"                          >> $(WAYLAND_PKG)/.PKGINFO ; \
	 echo "arch=$(WAYLAND_PKG_ARCH)"                               >> $(WAYLAND_PKG)/.PKGINFO ; \
	 echo "distroname=$(WAYLAND_PKG_DISTRO_NAME)"                  >> $(WAYLAND_PKG)/.PKGINFO ; \
	 echo "distrover=$(WAYLAND_PKG_DISTRO_VERSION)"                >> $(WAYLAND_PKG)/.PKGINFO ; \
	 echo "group=$(WAYLAND_PKG_GROUP)"                             >> $(WAYLAND_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(WAYLAND_PKG_SHORT_DESCRIPTION)\"" >> $(WAYLAND_PKG)/.PKGINFO ; \
	 echo "url=$(WAYLAND_PKG_URL)"                                 >> $(WAYLAND_PKG)/.PKGINFO ; \
	 echo "license=$(WAYLAND_PKG_LICENSE)"                         >> $(WAYLAND_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(WAYLAND_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
