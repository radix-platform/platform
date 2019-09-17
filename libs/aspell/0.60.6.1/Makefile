
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


SOURCE_REQUIRES    = sources/GNU/aspell

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
endif
REQUIRES          += libs/ncurses/6.0

# ======= __END_OF_REQUIRES__ =======


version            = 0.60.6.1
base_version       = $(shell echo $(version) | sed -e 's/\([0-9].[0-9]*\)\([\.].*\)/\1/')
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/aspell/aspell-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/aspell-$(version)
src_dir_name       = aspell-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ASPELL_PKG_NAME                = aspell
ASPELL_PKG_VERSION             = 0.60.6.1
ASPELL_PKG_ARCH                = $(TOOLCHAIN)
ASPELL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ASPELL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ASPELL_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
ASPELL_PKG_SHORT_DESCRIPTION   = spell checker
ASPELL_PKG_URL                 = $(BUG_URL)
ASPELL_PKG_LICENSE             = LGPLv2
ASPELL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ASPELL_PKG_NAME)-pkg-description
ASPELL_PKG_DESCRIPTION_FILE_IN = $(ASPELL_PKG_NAME)-pkg-description.in
ASPELL_PKG_INSTALL_SCRIPT      = $(ASPELL_PKG_NAME)-pkg-install.sh

ASPELL_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ASPELL_PKG_NAME)-package

pkg_basename     = $(ASPELL_PKG_NAME)-$(ASPELL_PKG_VERSION)-$(ASPELL_PKG_ARCH)-$(ASPELL_PKG_DISTRO_NAME)-$(ASPELL_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(ASPELL_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-rpath


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ASPELL_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(ASPELL_PKG)/usr/lib$(LIBSUFFIX) ; ln -sf aspell-$(base_version) aspell )
	@rm -f $(ASPELL_PKG)/usr/share/info/dir
	@gzip -9 $(ASPELL_PKG)/usr/share/info/*
	@if [ -d $(ASPELL_PKG)/usr/share/man ]; then \
	  ( cd $(ASPELL_PKG)/usr/share/man ; \
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
	# ======= Install Documentation =======
	@mkdir -p $(ASPELL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(ASPELL_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(ASPELL_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS COPYING README TODO \
	         manual/aspell-dev.html manual/aspell.html \
	         $(ASPELL_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(ASPELL_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(ASPELL_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libaspell.la libpspell.la \
	 )
	@( cd $(ASPELL_PKG)/usr/lib$(LIBSUFFIX)/aspell-$(base_version) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" context-filter.la email-filter.la \
	                                    nroff-filter.la sgml-filter.la    \
	                                    tex-filter.la texinfo-filter.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ASPELL_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libaspell.la libpspell.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libaspell.la libpspell.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/aspell-$(base_version) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" context-filter.la email-filter.la \
	                                            nroff-filter.la sgml-filter.la    \
	                                            tex-filter.la texinfo-filter.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" context-filter.la email-filter.la \
	                                              nroff-filter.la sgml-filter.la    \
	                                              tex-filter.la texinfo-filter.la ; \
	 )
	# ======= Strip binaries =======
	@( cd $(ASPELL_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(ASPELL_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(ASPELL_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(ASPELL_PKG_DESCRIPTION_FILE): $(ASPELL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ASPELL_PKG_DESCRIPTION_FILE) $(ASPELL_PKG_INSTALL_SCRIPT)
	@cp $(ASPELL_PKG_DESCRIPTION_FILE) $(ASPELL_PKG)/.DESCRIPTION
	@cp $(ASPELL_PKG_INSTALL_SCRIPT) $(ASPELL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ASPELL_PKG)/.REQUIRES
	@echo "pkgname=$(ASPELL_PKG_NAME)"                            >  $(ASPELL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ASPELL_PKG_VERSION)"                          >> $(ASPELL_PKG)/.PKGINFO ; \
	 echo "arch=$(ASPELL_PKG_ARCH)"                               >> $(ASPELL_PKG)/.PKGINFO ; \
	 echo "distroname=$(ASPELL_PKG_DISTRO_NAME)"                  >> $(ASPELL_PKG)/.PKGINFO ; \
	 echo "distrover=$(ASPELL_PKG_DISTRO_VERSION)"                >> $(ASPELL_PKG)/.PKGINFO ; \
	 echo "group=$(ASPELL_PKG_GROUP)"                             >> $(ASPELL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ASPELL_PKG_SHORT_DESCRIPTION)\"" >> $(ASPELL_PKG)/.PKGINFO ; \
	 echo "url=$(ASPELL_PKG_URL)"                                 >> $(ASPELL_PKG)/.PKGINFO ; \
	 echo "license=$(ASPELL_PKG_LICENSE)"                         >> $(ASPELL_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(ASPELL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
