
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


SOURCE_REQUIRES    = sources/packages/m/rtmpdump

REQUIRES           = libs/zlib/1.2.8
REQUIRES          += net/openssl/1.0.2f

# ======= __END_OF_REQUIRES__ =======


version            = 2.4
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/rtmpdump/rtmpdump-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/rtmpdump-$(version)
src_dir_name       = rtmpdump-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
RTMPDUMP_PKG_NAME                = rtmpdump
RTMPDUMP_PKG_VERSION             = 2.4
RTMPDUMP_PKG_ARCH                = $(TOOLCHAIN)
RTMPDUMP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
RTMPDUMP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
RTMPDUMP_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
RTMPDUMP_PKG_SHORT_DESCRIPTION   = RTMP streaming media client
RTMPDUMP_PKG_URL                 = $(BUG_URL)
RTMPDUMP_PKG_LICENSE             = GPLv2
RTMPDUMP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(RTMPDUMP_PKG_NAME)-pkg-description
RTMPDUMP_PKG_DESCRIPTION_FILE_IN = $(RTMPDUMP_PKG_NAME)-pkg-description.in
RTMPDUMP_PKG_INSTALL_SCRIPT      = $(RTMPDUMP_PKG_NAME)-pkg-install.sh

RTMPDUMP_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(RTMPDUMP_PKG_NAME)-package

pkg_basename     = $(RTMPDUMP_PKG_NAME)-$(RTMPDUMP_PKG_VERSION)-$(RTMPDUMP_PKG_ARCH)-$(RTMPDUMP_PKG_DISTRO_NAME)-$(RTMPDUMP_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(RTMPDUMP_PKG)


CFLAGS += -Wno-unused-but-set-variable


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) prefix="/usr"                  \
	                                bindir="/usr/bin"              \
	                                sbindir="/usr/sbin"            \
	                                libdir="/usr/lib$(LIBSUFFIX)"  \
	                                mandir="/usr/share/man"      ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(RTMPDUMP_PKG)
	@( cd $(SRC_DIR) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 prefix="/usr"                  \
	                                    bindir="/usr/bin"              \
	                                    sbindir="/usr/sbin"            \
	                                    libdir="/usr/lib$(LIBSUFFIX)"  \
	                                    mandir="/usr/share/man" $(env_sysroot) install ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(RTMPDUMP_PKG)/usr/share/man ]; then \
	  ( cd $(RTMPDUMP_PKG)/usr/share/man ; \
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
	@mkdir -p $(RTMPDUMP_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(RTMPDUMP_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/librtmp/COPYING \
	       $(RTMPDUMP_PKG)/usr/doc/$(src_dir_name)/COPYING.librtmp
	@mkdir -p $(RTMPDUMP_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README \
	         $(RTMPDUMP_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a librtmp/COPYING \
	         $(RTMPDUMP_PKG)/usr/share/doc/$(src_dir_name)/COPYING.librtmp ; \
	   cp -a *.html \
	         $(RTMPDUMP_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(RTMPDUMP_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(RTMPDUMP_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" librtmp.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(RTMPDUMP_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(RTMPDUMP_PKG_DESCRIPTION_FILE): $(RTMPDUMP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(RTMPDUMP_PKG_DESCRIPTION_FILE) $(RTMPDUMP_PKG_INSTALL_SCRIPT)
	@cp $(RTMPDUMP_PKG_DESCRIPTION_FILE) $(RTMPDUMP_PKG)/.DESCRIPTION
	@cp $(RTMPDUMP_PKG_INSTALL_SCRIPT) $(RTMPDUMP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(RTMPDUMP_PKG)/.REQUIRES
	@echo "pkgname=$(RTMPDUMP_PKG_NAME)"                            >  $(RTMPDUMP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(RTMPDUMP_PKG_VERSION)"                          >> $(RTMPDUMP_PKG)/.PKGINFO ; \
	 echo "arch=$(RTMPDUMP_PKG_ARCH)"                               >> $(RTMPDUMP_PKG)/.PKGINFO ; \
	 echo "distroname=$(RTMPDUMP_PKG_DISTRO_NAME)"                  >> $(RTMPDUMP_PKG)/.PKGINFO ; \
	 echo "distrover=$(RTMPDUMP_PKG_DISTRO_VERSION)"                >> $(RTMPDUMP_PKG)/.PKGINFO ; \
	 echo "group=$(RTMPDUMP_PKG_GROUP)"                             >> $(RTMPDUMP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(RTMPDUMP_PKG_SHORT_DESCRIPTION)\"" >> $(RTMPDUMP_PKG)/.PKGINFO ; \
	 echo "url=$(RTMPDUMP_PKG_URL)"                                 >> $(RTMPDUMP_PKG)/.PKGINFO ; \
	 echo "license=$(RTMPDUMP_PKG_LICENSE)"                         >> $(RTMPDUMP_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(RTMPDUMP_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
