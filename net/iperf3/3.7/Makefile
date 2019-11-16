
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
COMPONENT_TARGETS += $(HARDWARE_RK3328_CC)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_EDGE)
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
COMPONENT_TARGETS += $(HARDWARE_OKMX6DL_C)
COMPONENT_TARGETS += $(HARDWARE_OKMX6Q_C)
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


SOURCE_REQUIRES    = sources/packages/n/iperf3

REQUIRES           = net/openssl/1.1.1d

# ======= __END_OF_REQUIRES__ =======


version            = 3.7
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/n/iperf3/iperf-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/iperf-$(version)
src_dir_name       = iperf-$(version)
doc_dir_name       = iperf3-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
IPERF3_PKG_NAME                = iperf3
IPERF3_PKG_VERSION             = 3.7
IPERF3_PKG_ARCH                = $(TOOLCHAIN)
IPERF3_PKG_DISTRO_NAME         = $(DISTRO_NAME)
IPERF3_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
IPERF3_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
IPERF3_PKG_SHORT_DESCRIPTION   = bandwidth measurement tool
IPERF3_PKG_URL                 = $(BUG_URL)
IPERF3_PKG_LICENSE             = BSD
IPERF3_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(IPERF3_PKG_NAME)-pkg-description
IPERF3_PKG_DESCRIPTION_FILE_IN = $(IPERF3_PKG_NAME)-pkg-description.in
IPERF3_PKG_INSTALL_SCRIPT      = $(IPERF3_PKG_NAME)-pkg-install.sh

IPERF3_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(IPERF3_PKG_NAME)-package

pkg_basename     = $(IPERF3_PKG_NAME)-$(IPERF3_PKG_VERSION)-$(IPERF3_PKG_ARCH)-$(IPERF3_PKG_DISTRO_NAME)-$(IPERF3_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(IPERF3_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --with-pic

extra_configure_switches += --enable-static=no
extra_configure_switches += --enable-shared=yes


CFLAGS += -Wno-maybe-uninitialized -Wno-format

LDFLAGS += -Wl,-rpath,/lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


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
	@( cd $(build_dir) ; \
	   for file in `find . -name "Makefile"` ; do \
	     sed -i "s,-fomit-frame-pointer,,g" $$file ; \
	   done ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(IPERF3_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(IPERF3_PKG)/usr/share/man ]; then \
	  ( cd $(IPERF3_PKG)/usr/share/man ; \
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
	@mkdir -p $(IPERF3_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/LICENSE \
	       $(IPERF3_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(IPERF3_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a LICENSE README.md RELNOTES.md contrib \
	         $(IPERF3_PKG)/usr/share/doc/$(doc_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(IPERF3_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(IPERF3_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libiperf.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(IPERF3_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   libiperf.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libiperf.la ; \
	 )
	# ======= Strip binaries =======
	@( cd $(IPERF3_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(IPERF3_PKG_DESCRIPTION_FILE): $(IPERF3_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(IPERF3_PKG_DESCRIPTION_FILE) $(IPERF3_PKG_INSTALL_SCRIPT)
	@cp $(IPERF3_PKG_DESCRIPTION_FILE) $(IPERF3_PKG)/.DESCRIPTION
	@cp $(IPERF3_PKG_INSTALL_SCRIPT) $(IPERF3_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(IPERF3_PKG)/.REQUIRES
	@echo "pkgname=$(IPERF3_PKG_NAME)"                            >  $(IPERF3_PKG)/.PKGINFO ; \
	 echo "pkgver=$(IPERF3_PKG_VERSION)"                          >> $(IPERF3_PKG)/.PKGINFO ; \
	 echo "arch=$(IPERF3_PKG_ARCH)"                               >> $(IPERF3_PKG)/.PKGINFO ; \
	 echo "distroname=$(IPERF3_PKG_DISTRO_NAME)"                  >> $(IPERF3_PKG)/.PKGINFO ; \
	 echo "distrover=$(IPERF3_PKG_DISTRO_VERSION)"                >> $(IPERF3_PKG)/.PKGINFO ; \
	 echo "group=$(IPERF3_PKG_GROUP)"                             >> $(IPERF3_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(IPERF3_PKG_SHORT_DESCRIPTION)\"" >> $(IPERF3_PKG)/.PKGINFO ; \
	 echo "url=$(IPERF3_PKG_URL)"                                 >> $(IPERF3_PKG)/.PKGINFO ; \
	 echo "license=$(IPERF3_PKG_LICENSE)"                         >> $(IPERF3_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(IPERF3_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
