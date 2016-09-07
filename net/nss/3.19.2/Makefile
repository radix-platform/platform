
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

NO_CCACHE    = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/mozilla-nss

REQUIRES           = net/nspr/4.10.8
REQUIRES          += app/sqlite/3.12.2.0

# ======= __END_OF_REQUIRES__ =======


version            = 3.19.2
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/n/mozilla-nss/nss-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/nss-$(version)
src_dir_name       = nss-$(version)
doc_dir_name       = nss-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

nss_config_in      = $(CURDIR)/config/nss-config.in
nss_pc_in          = $(CURDIR)/config/nss.pc.in

nspr_version       = $(strip \
                       $(foreach pkg, $(REQUIRES), \
                         $(if $(shell echo $(pkg) | grep "net/nspr/"),\
                           $(shell echo $(pkg) | cut -f 3 -d '/' | cut -f 1 -d '-'),)))

####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
NSS_PKG_NAME                = nss
NSS_PKG_VERSION             = 3.19.2
NSS_PKG_ARCH                = $(TOOLCHAIN)
NSS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
NSS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
NSS_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
NSS_PKG_SHORT_DESCRIPTION   = Mozilla Network Security Services
NSS_PKG_URL                 = $(BUG_URL)
NSS_PKG_LICENSE             = MPLv2
NSS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NSS_PKG_NAME)-pkg-description
NSS_PKG_DESCRIPTION_FILE_IN = $(NSS_PKG_NAME)-pkg-description.in
NSS_PKG_INSTALL_SCRIPT      = $(NSS_PKG_NAME)-pkg-install.sh

NSS_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NSS_PKG_NAME)-package

pkg_basename     = $(NSS_PKG_NAME)-$(NSS_PKG_VERSION)-$(NSS_PKG_ARCH)-$(NSS_PKG_DISTRO_NAME)-$(NSS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


#
# BUILD Machine environment
#
nss_build_environment  = OS_TARGET=Linux
nss_build_environment += OS_RELEASE=
nss_build_environment += OS_REL_CFLAGS=
nss_build_environment += CPU_ARCH=x86
nss_build_environment += ARCHFLAG=-m64
nss_build_environment += LIBC_TAG=_glibc
nss_build_environment += USE_PTHREADS=1
nss_build_environment += BUILD_OPT=1
nss_build_environment += OPT_CODE_SIZE=1

NSS_BUILD_OBJ_DIR      = Linux_x86_glibc_PTH_OPT.OBJ

#
# TARGET Machine environment
#
nss_environment     = OS_TARGET=Linux
nss_environment    += OS_RELEASE=
nss_environment    += OS_REL_CFLAGS="$(ARCH_DEFS) -I$(TARGET_DEST_DIR)/usr/include/nspr"

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
nss_environment    += USE_64=1
nss_environment    += ARCHFLAG="-m64"
else
nss_environment    += ARCHFLAG="$(ARCH_FLAGS)"
endif

nss_environment    += LIBC_TAG=_glibc
nss_environment    += USE_PTHREADS=1
nss_environment    += BUILD_OPT=1
nss_environment    += OPT_CODE_SIZE=1
nss_environment    += NSDISTMODE="copy"

nss_environment    += USE_SYSTEM_ZLIB=1 ZLIB_LIBS=-lz NSS_USE_SYSTEM_SQLITE=1

nss_environment    += CC="$(CC) --sysroot=$(TARGET_DEST_DIR)"
nss_environment    += CCC="$(CXX) --sysroot=$(TARGET_DEST_DIR)"
nss_environment    += RANLIB="$(RANLIB)"

nss_environment    += NSPR_LDFLAGS=" -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)"
nss_environment    += RPATH=-Wl,-rpath,'/lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)'

nss_environment    += CROSS_COMPILE=1

#
# TARGET Machine HW depended environment
#

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
nss_environment    += CPU_ARCH=x86_32
NSS_TARGET_OBJ_DIR  = Linux_x86_32_$(TARGET)-gcc_glibc_PTH_OPT.OBJ
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
nss_environment    += CPU_ARCH=x86_64
NSS_TARGET_OBJ_DIR  = Linux_x86_64_$(TARGET)-gcc_glibc_PTH_64_OPT.OBJ
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)),)
nss_environment    += CPU_ARCH=armv7a
NSS_TARGET_OBJ_DIR  = Linux_armv7a_$(TARGET)-gcc_glibc_PTH_OPT.OBJ
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB2X) $(HARDWARE_CB3X)),)
nss_environment    += CPU_ARCH=armv7ve
NSS_TARGET_OBJ_DIR  = Linux_armv7ve_$(TARGET)-gcc_glibc_PTH_OPT.OBJ
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_FFRK3288)),)
nss_environment    += CPU_ARCH=armv7ve
NSS_TARGET_OBJ_DIR  = Linux_armv7ve_$(TARGET)-gcc_glibc_PTH_OPT.OBJ
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_M201) $(HARDWARE_MXQ)),)
nss_environment    += CPU_ARCH=armv7a
NSS_TARGET_OBJ_DIR  = Linux_armv7a_$(TARGET)-gcc_glibc_PTH_OPT.OBJ
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_NIT6Q)),)
nss_environment    += CPU_ARCH=armv7a
NSS_TARGET_OBJ_DIR  = Linux_armv7a_$(TARGET)-gcc_glibc_PTH_OPT.OBJ
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
nss_environment    += CPU_ARCH=armv7a
NSS_TARGET_OBJ_DIR  = Linux_armv7a_$(TARGET)-gcc_glibc_PTH_OPT.OBJ
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20)),)
nss_environment    += CPU_ARCH=mips32r2
NSS_TARGET_OBJ_DIR  = Linux_mips32r2_$(TARGET)-gcc_glibc_PTH_OPT.OBJ
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_BT1)),)
nss_environment    += CPU_ARCH=mips32r5
NSS_TARGET_OBJ_DIR  = Linux_mips32r5_$(TARGET)-gcc_glibc_PTH_OPT.OBJ
endif


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	# ======= remove 'nsinstall' from coreconf SUBDIRS; add NSPR LDFLAGS =======
	@( cd $(SRC_DIR)/coreconf ; \
	   sed -i "s,^\(DIRS.*=\).*,\1," Makefile ; \
	   sed -i "s,^\(MKSHLIB.*\).*,\1 $$\(NSPR_LDFLAGS\)," Linux.mk ; \
	 )
	# ======= make nsinstall & mkdepend utils for BUILD Machine =======
	@( cd $(SRC_DIR)/coreconf/nsinstall ; \
	   $(MAKE) -j1 $(nss_build_environment) ; \
	   mkdir -p $(NSS_TARGET_OBJ_DIR)       ; \
	   cd $(NSS_BUILD_OBJ_DIR) && cp * ../$(NSS_TARGET_OBJ_DIR)/ ; \
	 )
	@( cd $(SRC_DIR)/coreconf/mkdepend && \
	   $(MAKE) -j1 $(nss_build_environment) ; \
	   mkdir -p $(NSS_TARGET_OBJ_DIR)       ; \
	   cd $(NSS_BUILD_OBJ_DIR) && cp * ../$(NSS_TARGET_OBJ_DIR)/ ; \
	 )
	# ======= build NSS =======
	@( cd $(SRC_DIR) ; \
	   $(MAKE) -j1 $(nss_environment) ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(NSS_PKG)/usr/{bin,lib$(LIBSUFFIX)/pkgconfig,include/nss}
	@( cd $(TARGET_BUILD_DIR)/dist/$(NSS_TARGET_OBJ_DIR)  ; \
	   for file in certutil cmsutil crlutil derdump modutil \
	               pk12util pp shlibsign signtool signver   \
	               ssltap vfychain vfyserv ; do \
	     cp -a bin/$$file  $(NSS_PKG)/usr/bin ; \
	   done ; \
	   cp -a lib/* $(NSS_PKG)/usr/lib$(LIBSUFFIX) ; \
	 )
	@( cd $(TARGET_BUILD_DIR)/dist/public ; \
	   cp -a nss/* $(NSS_PKG)/usr/include/nss ; \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(NSS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(NSS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(NSS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING doc/html \
	         $(NSS_PKG)/usr/share/doc/$(src_dir_name) ; \
	   if [ -r .hg_archival.txt ]; then \
	     cp -a .hg_archival.txt $(NSS_PKG)/usr/share/doc/$(src_dir_name) ; \
	   fi ; \
	   rm -f $(NSS_PKG)/usr/share/doc/$(src_dir_name)/html/.hgignore ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(NSS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= install 'nss.pc' pkgconfig file =======
	@sed -e "s,@PREFIX@,/usr,g" \
	     -e "s,@LIBDIRSUFFIX@,$(LIBSUFFIX),g" \
	     -e "s,@VERSION@,$(version),g" \
	     -e "s,@NSPR_VERSION@,$(nspr_version),g" \
	     $(nss_pc_in) > $(NSS_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig/nss.pc
	@( cd $(NSS_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   ln -sf nss.pc mozilla-nss.pc ; \
	 )
	# ======= install 'nss-config' script =======
	@sed -e "s,@PREFIX@,/usr,g" \
	     -e "s,@LIBDIRSUFFIX@,$(LIBSUFFIX),g" \
	     -e "s,@MOD_MAJOR_VERSION@,$(shell echo $(version) | cut -f 1 -d '.'),g" \
	     -e "s,@MOD_MINOR_VERSION@,$(shell echo $(version) | cut -f 2 -d '.'),g" \
	     -e "s,@MOD_PATCH_VERSION@,$(shell echo $(version) | cut -f 3 -d '.'),g" \
	     $(nss_config_in) > $(NSS_PKG)/usr/bin/nss-config
	@chmod 755 $(NSS_PKG)/usr/bin/nss-config
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(NSS_PKG))
	# ======= tune nss-config to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" nss-config ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" nss.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(NSS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(NSS_PKG_DESCRIPTION_FILE): $(NSS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(NSS_PKG_DESCRIPTION_FILE) $(NSS_PKG_INSTALL_SCRIPT)
	@cp $(NSS_PKG_DESCRIPTION_FILE) $(NSS_PKG)/.DESCRIPTION
	@cp $(NSS_PKG_INSTALL_SCRIPT) $(NSS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NSS_PKG)/.REQUIRES
	@echo "pkgname=$(NSS_PKG_NAME)"                            >  $(NSS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NSS_PKG_VERSION)"                          >> $(NSS_PKG)/.PKGINFO ; \
	 echo "arch=$(NSS_PKG_ARCH)"                               >> $(NSS_PKG)/.PKGINFO ; \
	 echo "distroname=$(NSS_PKG_DISTRO_NAME)"                  >> $(NSS_PKG)/.PKGINFO ; \
	 echo "distrover=$(NSS_PKG_DISTRO_VERSION)"                >> $(NSS_PKG)/.PKGINFO ; \
	 echo "group=$(NSS_PKG_GROUP)"                             >> $(NSS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NSS_PKG_SHORT_DESCRIPTION)\"" >> $(NSS_PKG)/.PKGINFO ; \
	 echo "url=$(NSS_PKG_URL)"                                 >> $(NSS_PKG)/.PKGINFO ; \
	 echo "license=$(NSS_PKG_LICENSE)"                         >> $(NSS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(NSS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
